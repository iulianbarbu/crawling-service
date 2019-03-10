import java.io.File;
import java.io.IOException;

import org.openqa.selenium.By;
import org.openqa.selenium.firefox.FirefoxBinary;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.firefox.FirefoxProfile;
import org.openqa.selenium.firefox.GeckoDriverService;
import org.openqa.selenium.firefox.ProfilesIni;

public class Selenium3Demo {
	public static void main(String[] args) {
		System.setProperty("webdriver.gecko.driver", "/home/iulian/Licenta/geckodriver-v0.24.0-linux64/geckodriver");

		ProfilesIni ini = new ProfilesIni();


		// Change the profile name to your own. The profile name can 
		// be found under .mozilla folder ~/.mozilla/firefox/profile. 
		// See you profile.ini for the default profile name

		FirefoxProfile profile = ini.getProfile("default"); 
		FirefoxBinary firefoxBinary = new FirefoxBinary();

		GeckoDriverService service =new GeckoDriverService.Builder()
				.usingFirefoxBinary(firefoxBinary)
		        .usingDriverExecutable(new File("/home/iulian/Licenta/geckodriver-v0.24.0-linux64/geckodriver"))
		        .usingAnyFreePort()
		        .build();
		try {
		    service.start();
		} catch (IOException e) {
		    e.printStackTrace();
		}

		FirefoxOptions options = new FirefoxOptions().setBinary(firefoxBinary).setProfile(profile).setAcceptInsecureCerts(true);

		FirefoxDriver driver = new FirefoxDriver(options);
		driver.get("https://firefox-source-docs.mozilla.org/testing/geckodriver/geckodriver/Support.html");

		System.out.println("Life Title -> " + driver.getTitle());

		String innerHtml = driver.findElement(By.tagName("body")).getAttribute("innerHTML");
		System.out.println(innerHtml);
		driver.close();
		service.stop();
	}
}
