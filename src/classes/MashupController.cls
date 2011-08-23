/**
 * @author Pat Patterson - ppatterson@salesforce.com
 */

global with sharing class MashupController extends FacebookLoginController {
    static SimpleGeo client = new SimpleGeo();
    static String startRadius = '5';
    static String presence = '3600'; // One hour
    static String refresh = '30';
    
    public static String getRadius() {
        return startRadius;
    }

    public static String getPresenceTimeout() {
        return presence;
    }

    public static String getRefreshTimeout() {
        return refresh;
    }

    public static String getLocationFromIP() {
        String ip = ApexPages.CurrentPage().getHeaders().get('x-Salesforce-SIP');
        
        SimpleGeo.Context context = client.getContextFromIPAddress(ip);
        
        return '{latitude: "'+context.query.latitude+'",longitude:"'+context.query.longitude+'"}';
    }
    
    // Returns JSON string with user info
    public static String getFacebookUser() {
        return FacebookObject.doAPICallRaw('me', null, null);
    }
    
    // Returns JSON string with friend list
    public static String getFacebookFriends() {
        return FacebookObject.doAPICallRaw('me', 'friends', null);
    }
    
    // Given a FB user id and name, and latitude/longitude, push that up to 
    // SimpleGeo and get a list of features representing other nearby users
    @RemoteAction
    global static String getNearbyUsers(String fbid, String name, Double latitude, Double longitude, Double radius) {
        SimpleGeo.Feature feature = new SimpleGeo.Feature();
        feature.geometry = new SimpleGeo.Point(latitude, longitude);
        feature.properties = new Map<String, SimpleGeo.PropertyValue>{
					  'name' => new SimpleGeo.PropertyValue(name)
				};
        
        client.putRecord('com.force.df11.mashup', fbid, feature);
        
        String url = '/0.1/records/com.force.df11.mashup/nearby/'+
            latitude+','+longitude+'.json?radius='+radius;
        return client.sendRequestRaw(url, null, null);
    }
}