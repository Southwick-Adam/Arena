extends Node2D

# Configure the script by changing the values below.

# Retry connection if fail, if set to 0 it wont retry.
var retryConnectionInterval = 8.0
var autoLoad = true

var useTestAds = true
var bannerDisplayTop = true

export var testAdBannerId = "ca-app-pub-3940256099942544/6300978111"
export var testAdInterstitialId = "ca-app-pub-3940256099942544/1033173712"
export var testAdRewardedId = "ca-app-pub-3940256099942544/5224354917"

var adBannerId = "my official banner id here"
var adInterstitialId = "my official interstitial id here"
var adRewardedId = "my official rewarded id here"

var useBanner = false
var useInterstitial = true
var useRewardedVideo = true

#####################################################
# In case you want to use a specific content rating #
#####################################################

## Set this to yes to make the configurations below it apply.
var useContentRating = false
var childDirectedTreatment = false
var maxContentRating = "G"

# Non Configurable variables

var bannerReady = false
var interstitialReady = false
var	rewardedReady = false
var admob = null

# Helpers

func _retry_connection_with_delay():
	print("Trying to reconnect after: " + str(retryConnectionInterval) + " seconds")
	yield(get_tree().create_timer(retryConnectionInterval), "timeout")
	_initialize_ads()
	
func _initialize_ads():
	var realAds = not useTestAds
	var instance = get_instance_id()
	
	if (!useContentRating):
		admob.init(realAds, instance)
	else:
		var childFriendly = childDirectedTreatment
		var rating = maxContentRating
		admob.initWithContentRating(realAds, instance, childFriendly, rating)

# Startup

func _ready():
	
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		
		_initialize_ads()
		
		if (useBanner):
			loadBanner()
# warning-ignore:return_value_discarded
			get_tree().connect("screen_resized", self, "onResize")
			
		if (useInterstitial):
			loadInterstitial()
			
		if (useRewardedVideo):
			loadRewardedVideo()

# Loaders

func loadBanner():
	if admob != null:
		var id = testAdBannerId if useTestAds else adBannerId
		admob.loadBanner(id, bannerDisplayTop)

func loadInterstitial():
	if admob != null:
		var id = testAdInterstitialId if useTestAds else adInterstitialId;
		admob.loadInterstitial(id)
		
func loadRewardedVideo():
	if admob != null:
		var id = testAdRewardedId if useTestAds else adRewardedId
		admob.loadRewardedVideo(id)

# Showing the ads

func showBanner():
	if admob != null and bannerReady:
		admob.showBanner()
		return true
	return false
		
func hideBanner():
	if admob != null and bannerReady:
		admob.hideBanner()
		return true
	return false
	
func showInterstitial():
	if admob != null and interstitialReady:
		admob.showInterstitial()
		return true
	return false
		
func showRewardedVideo():
	if admob != null and rewardedReady:
		admob.showRewardedVideo()
		return true
	return false

# Events

func _on_admob_network_error():
	print("Network Error")
	if (retryConnectionInterval > 0):
		_retry_connection_with_delay()

func _on_admob_ad_loaded():
	print("Banner load success")
	bannerReady = true

func _on_interstitial_not_loaded():
	print("Error: Interstitial not loaded")
	interstitialReady = false

func _on_interstitial_loaded():
	print("Interstitial loaded")
	interstitialReady = true

func _on_interstitial_close():
	print("Interstitial closed")
	get_node("/root/main").games_played_no_ad = 0
	get_node("root/main").Interstitial_ready = false
	interstitialReady = false

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	rewardedReady = true
	
func _on_rewarded_video_ad_closed():
	#get_node("/root/main/Label").text = ("not rewarded") ##TEMP
	get_node("/root/main/save_screen")._close()
	rewardedReady = false
	loadRewardedVideo()
	
func _on_rewarded():
	get_node("/root/main/Label").text = ("rewarded") ##TEMP
	get_node("/root/main/save_screen")._revive()

# Resize

func onResize():
	if admob != null:
		admob.resize()
