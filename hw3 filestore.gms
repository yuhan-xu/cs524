$title hw3 filestore

* create a set of mediums
Set medium/hardDisk,memory,cloud/;

* create a set of file types(ftype)
Set ftype/wordProc,packageProg,data/;
positive variables store(medium,ftype);

* create a table stating the time is takes for the file to be retrieved depends on the type of file and the storage medium                   
table a(medium,ftype)
           wordProc   packageProg   data
hardDisk   5          4             4
memory     2          1             1
cloud      10         8             6
;

free variable tottime "the total time per month that users spend accessing their files";

parameters
  access(ftype)/"wordProc" 8,"packageProg" 4,"data" 2/;
  

equations hardDiskLimit    "max amount of files that can be added to hard disk"
          memoryLimit      "max amount of files that can be added to memory"
          cloudLimit       "max amount of files that can be added to cloud"
          wordProcLimit    "amount of word-processing files that users want to store"
          packageProgLimit "amount of packaged-program files that users want to store"
          dataLimit        "amount of data files that users want to store"
          objfunc;

* EQUATION (MODEL) DEFINITION
hardDiskLimit..
  sum(ftype,store("hardDisk",ftype)) =l= 200;
  
memoryLimit..
  sum(ftype,store("memory",ftype)) =l= 100;
  
cloudLimit..
  sum(ftype,store("cloud",ftype)) =l= 300;

wordProcLimit..
  sum(medium,store(medium,"wordProc")) =e= 300;

packageProgLimit..
  sum(medium,store(medium,"packageProg")) =e= 100;
  
dataLimit..
  sum(medium,store(medium,"data")) =e= 100;
  
* Objective function  
objfunc..
  tottime =e= sum(medium,sum(ftype,a(medium,ftype)*store(medium,ftype)*access(ftype)));
  
model filestore /all/;

solve filestore using lp min tottime;