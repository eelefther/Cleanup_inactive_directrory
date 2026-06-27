function cleanup
    set target_directory $argv[1]
    set days_inactive $argv[2]
    set recursive $argv[3]
    set dry_run $argv[4]
    set excluded_files_dirs (string split " " $argv[5])
    set sort_type $argv[6]
    set confirmation $argv[7]
 
    mkdir -p ~/files_for_testing
    for i in (seq 1 7)
        mkdir -p ~/files_for_testing/testfolder$i
        touch -t 202311122300 ~/files_for_testing/testfolder$i/testfile$i.txt
    end
    touch -t 202311122300 ~/files_for_testing/recursive_test.txt

    set files_to_remove

    for file in (find $target_directory -type f)
        for item in $excluded_files_dirs
            if test -f $file; and string match -q "$item" (basename $file)
                set excluded_files_dirs $excluded_files_dirs $file
            end
        end
    end

    if test $recursive = true
        for file in (find $target_directory -type f)
            set -l current_time (date +%s)
            set -l last_access (stat -c %X $file)
            set -l seconds_since_access (math $current_time - $last_access)
            set -l seconds_in_day 86400
            
            # ΔΙΟΡΘΩΣΗ: Η πράξη της διαίρεσης κλείνεται σε παρένθεση με την εντολή math
            set -l days_since_access (math "$seconds_since_access / $seconds_in_day")
            
            # ΔΙΟΡΘΩΣΗ: Χρήση του test -gt (greater than) για αριθμητική σύγκριση στη Fish
            if test $days_since_access -gt $days_inactive
                if not contains -- $file $files_to_remove
                    if not contains -- $file $excluded_files_dirs
                        set files_to_remove $files_to_remove $file
                    end
                end
            end
        end
    else if test $recursive = false 
        for file in (find $target_directory -maxdepth 1 -type f)
            set -l current_time (date +%s)
            set -l last_access (stat -c %X $file)
            set -l seconds_since_access (math $current_time - $last_access)
            set -l seconds_in_day 86400
            
            # ΔΙΟΡΘΩΣΗ: Αντίστοιχη διόρθωση της διαίρεσης και εδώ
            set -l days_since_access (math "$seconds_since_access / $seconds_in_day")
            
            if test $days_since_access -gt $days_inactive
                if not contains -- $file $files_to_remove
                    if not contains -- $file $excluded_files_dirs
                        set files_to_remove $files_to_remove $file
                    end
                end
            end
        end
    end 
                        
    if test $sort_type = "asc"
        # ΔΙΟΡΘΩΣΗ: Αντικατάσταση του τυπογραφικού 't0' με σωστή εντολή find/sort
        find $files_to_remove -type f -exec ls -lhS {} + 2>/dev/null | sort -k 5,5 -h
    else if test $sort_type = "desc"
        find $files_to_remove -type f -exec ls -lhS {} + 2>/dev/null | sort -k 5,5 -hr
    end

    if test $dry_run = true
        if test $confirmation = true
            echo -n "Are you sure you want to proceed to the file cleanup? (y/n)"
            read -l yes_or_no
            if test "$yes_or_no" = "y" -o "$yes_or_no" = "Y"
                echo "deletion of unused files (dry_run mode)"
            else if test "$yes_or_no" = "n" -o "$yes_or_no" = "N"
                echo "unused files not deleted"
            end
        else if test $confirmation = false
            echo "deletion of unused files (dry_run mode)"
        end
    else if test $dry_run = false 
        if test $confirmation = true
            echo -n "Are you sure you want to proceed to the file cleanup? (y/n)"
            read -l yes_or_no
            if test "$yes_or_no" = "y" -o "$yes_or_no" = "Y"
                set i 0
                for item in $files_to_remove
                    rm -f $item
                    set i (math $i + 1)   
                end
                echo "The $i files above were deleted"
            else if test "$yes_or_no" = "n" -o "$yes_or_no" = "N"
                echo "unused files not deleted"
            end
        else if test $confirmation = false
            set j 0
            for item in $files_to_remove
                rm -f $item
                set j (math $j + 1)    
            end
            echo "The $j files above were deleted"
        end
    end
end
