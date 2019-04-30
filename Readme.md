 This application displays list of movies produced in the year 2017 and 2018 for a given search key.
 ### Application usage:
 Application has mainly two view controllers,
1. Movie search
2. Settings

 Valid API key is required to provide in settings view to use movie search. https://www.themoviedb.org/ 
 
###  Main classes:
1. ViewController 		            //For movie search
2. SettingsViewController       //For settings view
3. KeyChainWrapper   		         //For saving the API key in keychain
4. MoviesApi   			              //Dynamic library for REST API
5. static_lib.c 			             //Static library for sorting movies based on rating


