backup_dir="backup"
working_dir="working"
temp_dir="temp"
if [ "$(ls -A $backup_dir)" ]; then
    mkdir $temp_dir
    for entry in "$backup_dir"/*
    do
      rsync -av  --compare-dest=../$temp_dir/ $entry/ $working_dir
      rm -r $temp_dir
      rsync -av $working_dir/ $temp_dir/
    done
    rm -r $temp_dir
else
  echo "No backup found"
fi