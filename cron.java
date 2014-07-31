package workplease;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.*;
import javax.jdo.*;
import org.json.simple.*;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import org.scribe.builder.ServiceBuilder;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.oauth.OAuthService;


public class Yelp {

  OAuthService service;
  Token accessToken;

  /**
* Setup the Yelp API OAuth credentials.
* @param consumerKey Consumer key
* @param consumerSecret Consumer secret
* @param token Token
* @param tokenSecret Token secret
*/
  public Yelp(String consumerKey, String consumerSecret, String token, String tokenSecret) {
    this.service = new ServiceBuilder().provider(YelpApi2.class).apiKey(consumerKey).apiSecret(consumerSecret).build();
    this.accessToken = new Token(token, tokenSecret);
  }

  /**
* Search with offset.
*
* @param offset int
*/
  public String search(int offset) {
    OAuthRequest request = new OAuthRequest(Verb.GET, "http://api.yelp.com/v2/search?term=restaurants&location=corvallis");
    request.addQuerystringParameter("offset", offset);
    this.service.signRequest(this.accessToken, request);
    Response response = request.send();
    return response.getBody();
  }

  // CLI
  public static void main(String[] args) {
    String consumerKey = "mI-IldCQDzoRVe6jbSyNpA";
    String consumerSecret = "pl3Ao0fXT4iA4mf2g9vTM_ud-80";
    String token = "1VfCZ3flvJvJHvhJNq0la4GSEgh_W7RH";
    String tokenSecret = "UhA6q0YfR1g89SbhY9kKRE8yRF4";
    Yelp yelp = new Yelp(consumerKey, consumerSecret, token, tokenSecret);
    JSONArray restaurants = new JSONArray();
    int total_restaurants = 1000;
    int offset = 0;
	PersistenceManager pm = PMF.getPMF().getPersistenceManager();

    while(total_restaurants > offset){
    	JSONObject object = (JSONObject)new JSONParser().parse(yelp.search(offset));
    	total_restaurants = object.total;
    	restaurants.addAll(object.businesses);
        offset += 20;
    }
    
	for (JSONObject restaurant : restaurants) {
		if(restaurant.review_count < 3){
			Restaurant.createRestaurant(restaurant.name, pm);
		}
	}

  }
}