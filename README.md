# Powershell: KPIRetreiver

```
                                       .:-----=++++++++=====-::       
                               .--:=+++==-::--    .   :.-..::-#       
                             :=*+::=+   -.      - =  +-.=    --        
                         -=*=:      ::      ..:+:=.:===:...=:         
                       :=++-          .:.....         .:...:+.         
                     :+-=:  .::-:..:::.    :::=+**+++**+====*:         
                   +-:=        ==.   ::+=:..-#:......  .::.           
                 :+ =- ..:--:-:   -+:   ::.          ..:::.           
                 .* --   .  :-  .=- ==                     :=--        
                 #. *   .::=:  =- -=                 .:.:--:::.:::::.. 
               :* .=:::::-=  +. =-               .:--::.          -+*:
               =- -=-:.  +. := .*             :::..         .-=+*+-   
               +- *.  .--#  +: -=          .--.     .....:-. =%:      
               == +  -.=.-- +: -=        .-=:   .=..   :=-+:-.*#      
               .# +:+ .+  + -= .*      .-=-   :::-.:::::::...  *#     
                 =-.*:+ +   +:*  :+  .:--:    +  +:.         +=+**-    
                 #:-** = =::+::  +==:.       .-  ..:::::  --++%+      
                 :+ -= +-*: * .+:=:     +#:    :-      ::::+.=#*      
                   -=:-#.=%  %  :+*      =*=-    .=          . .:+.    
                   -+.=-+: *=  *=+     .+= #:-++==::.            .=:  
                     ==-: .#-  +#=      +*#.:-:       +=::=-=+==:::-   
                     **: *+ :**.  ..:-*#+:          -+:==:            
                     :% :%: :*+*=:++=-:            : ..::.=           
                     :#:=#      +-:+         .:.:::::     +           
                       ::: 888    # *.      -:             =           
                           888   ==+-    .-      ..      =            
            e88 88e        888
           d888 888b   e88 888 Y8b Y888P  dP"Y  dP"Y  ,e e,  8888 8888  dP"Y 
          C8888 8888D d888 888  Y8b Y8P  C88b  C88b  d88 88b 8888 8888 C88b  
           Y888 888P  Y888 888   Y8b Y    Y88D  Y88D 888   , Y888 888P  Y88D 
            "88 88"    "88 888    888    d,dP  d,dP   "YeeP"  "88 88"  d,dP  
                                  888                                        
                                  888                                        

                .:-------:                                                           
             :--.. .::::---:                                                         
          .-=:   .=-..-  -:=.                                                        
         :=.    :=.  --..=:=                              :-===-                     
       .=-      =-    :---.              :---:          .=::-  -:           .:---:   
      --.       =-                    .-:.=: --        :-. =:            .--=-:- =:  
   .-=.         .=:.   .:---        :-:  :=           -:   =-          :--..=. --:   
 :--.             .::::.:=...    :--.     --       .--.    .=-      .--.   .=.       
-:                       :------:.         .-------:         :------:       :=-:..::-

```

This project is a PowerShell tool that allows to post process data extracted from an active directory domain. 

## Requirements

This script requires Powershell 7.0 and ADRetreiver and ActiveDirectory modules

## Getting Started

To install this module, you first need to download the project. You can then copy the module to your modules directory and then load it with:

`Import-Module KPIRetreiver`

Symlink works perfectly too.

Alternatively, you can just import it directly from the project directory with:

`Import-Module C:\Path\To\KPIRetreiver`

Depending on your environment, dependencies may or may not be auto-imported. In case you end up with an error message, you can just import required modules before importing KPIRetreiver

## Usage