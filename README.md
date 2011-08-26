This is the code from my Dreamforce 2011 session: 'Mashing Up the Cloud with 
Force.com Toolkits'.

You can see the app in action at https://sgtest-developer-edition.na12.force.com/

If you're registered for Dreamforce 2011, the session page is 
https://dreamevent.my.salesforce.com/a0930000009YIP3

Prerequisites
-------------

* https://github.com/metadaddy-sfdc/sfdc-oauth-playground
* https://github.com/metadaddy-sfdc/Force.com-Toolkit-for-SimpleGeo
* https://github.com/metadaddy-sfdc/Force.com-Toolkit-for-Facebook

I'll also post the slides here after my session.

Instructions
------------

1. Create a new, clean Developer Edition org (http://developer.force.com/join).

2. Create a new Force.com project in the [Force.com IDE](http://wiki.developerforce.com/index.php/Force.com_IDE) using your new org's credentials. In the 'Choose Initial Project Contents' dialog, select 'Selected metadata components', hit 'Choose...' and select ALL of the components in the next page. This will give you a complete project directory tree.

3. Copy all static resources from DF11Mashup to the staticresources project sub-directory. For example:
        cp DF11Mashup/src/staticresources/* ~/Documents/workspace/Mashup/src/staticresources
You will need to adjust paths according to the location of your Eclipse workspace.

4. Copy the Geolocation test page:
```
cp DF11Mashup/src/pages/GeoTest.page* ~/Documents/workspace/Mashup/src/pages
```
    
5. In Eclipse, right click your project in the project explorer and click 'Refresh'. This causes Eclipse to scan the project directory tree for changes, and the plugin syncs changes to Force.com. This is the easiest way to push multiple changes to Force.com in one operation - we'll be using this technique several times in these instructions.
    
6. Go to the Geolocation test page. On my na12 DE org it is located at https://c.na12.visual.force.com/apex/GeoTest - you may need to change na12 to match your org's instance. You should be prompted by your browser to share your location with the page - go ahead and do so and you should see a JSON representation of your location.

7. [Sign up for a SimpleGeo account](https://simplegeo.com/signup/). Go to the [SimpleGeo Layers page](https://simplegeo.com/layers/) and add a new layer called com.force.df11.mashup.

8. Now copy the contents of sfdc-oauth-playground to the Eclipse project:
```
cd sfdc-oauth-playground
cp -r applications classes layouts objects pages tabs ~/Documents/workspace/Mashup/src/
```
Note that there are no slashes on the end of those directory names. If you add the slashes, it copies the contents of the directories to the src directory, which you don't want!

9. In Eclipse, right click your project in the project explorer and click 'Refresh'.

10. In the browser, go to Setup | App Setup | Create | Apps, click 'Edit' next to the OAuth Consumer Playground app, scroll down, and click the 'Visible' box next to System Administrator. Now go to Setup | Administration Setup | Manage Users | Profiles, click on 'Edit' next to System Administrator, scroll down to Custom Tab Settings and set 'API Tester', 'Authorize' and 'OAuth Services' to 'Default On'. 'OAuth Consumer Playground' should now be available in the dropdown list of apps (top right).

11. Select 'OAuth Consumer Playground' from apps list, click the 'OAuth Services' tab, click 'New' and enter the following data:
 * Service Name: SimpleGeo
 * Consumer Key: Key from https://simplegeo.com/tokens/
 * Consumer Secret: Secret from https://simplegeo.com/tokens/

12. Go to Setup | Administration Setup | Security Controls | Remote Site Settings and add http://api.simplegeo.com as a new remote site.

13. Click the API Tester tab, enter http://api.simplegeo.com/1.0/context/ip.json as the URL and click 'Send'. You should see a JSON representation of your IP address' location.

14. Now copy the contents of Force.com-Toolkit-for-SimpleGeo to the Eclipse project:
```
cd Force.com-Toolkit-for-SimpleGeo
cp -r classes pages ~/Documents/workspace/Mashup/src/
```
    
15. In Eclipse, right click your project in the project explorer and click 'Refresh'.

16. Go to the SimpleGeo test page. On my na12 DE org it is located at https://c.na12.visual.force.com/apex/SimpleGeoTest. You may be prompted again by your browser to share your location with the page (depending on your browser and whether you chose to always share your location). This time you should see your latitude and longitude and address.

17. Now copy the contents of Force.com-Toolkit-for-Facebook to the Eclipse project:
```
cd Force.com-Toolkit-for-Facebook
cp -r applications classes components objects pages staticresources tabs ~/Documents/workspace/Mashup/src
```

18. In the browser, go to Setup | App Setup | Create | Apps, click 'Edit' next to the Facebook Toolkit 3 app, scroll down, and click the 'Visible' box next to System Administrator. Now go to Setup | Administration Setup | Manage Users | Profiles, click on 'Edit' next to System Administrator, scroll down to Custom Tab Settings and set all of the Facebook tabs to 'Default On'. 'Facebook Toolkit 3' should now be available in the dropdown list of apps (top right).

19. Go to Setup | Administration Setup | Security Controls | Remote Site Settings and add https://graph.facebook.com as a new remote site.

20. Go to Setup | App Setup | Develop | Sites and create a new site with FacebookSamplePage as its home page. Ensure you activate the site. Once you have created the site, from the 'Sites' page, click the site label and add Mashup and SimpleMashup to the list of 'Site Visualforce Pages'.

21. Go to Setup | App Setup | Develop | Apex Classes | Schedule Apex and add FacebookHousekeeping - set it to run at midnight every night. This scheduled Apex job will remove expired session records from the FacebookSession__c object.

22. Go to https://developers.facebook.com/apps and create a new Facebook app. Under 'Website', set Site URL to your site's URL - for me it was http://sgtest-developer-edition.na12.force.com/

23. Back in your DE org, click the 'Facebook Apps' tab, Click 'New' and enter the following data:
 * FacebookApp Name: Mashup
 * clientID: App ID from your app's settings in Facebook
 * clientSecret: App Secret from your app's settings in Facebook

24. Go to your site URL (e.g. http://sgtest-developer-edition.na12.force.com/) and you should be prompted to authorize your new app. Do so and you should see a sample page showing your Facebook user info, profile picture, 'Like' button etc. Change the URL to e.g. http://sgtest-developer-edition.na12.force.com/SimpleMashup and you should see a list of nearby users. It will likely have a single entry. Now go to e.g. http://sgtest-developer-edition.na12.force.com/Mashup and you should see the full 'Nearby Users' UI, with (probably) an empty list of users, since it does not list you. Persuade a friend to go to that page and they should see you listed.
