<meta name="robots" content="noindex, nofollow" />
<script>

    function initSubscribe() {

        if (window.subscribeInitialized) {
            return;
        }

        $(document).on('loginchange subscriptionchange', (event) => {
            $('.geofs-subscribe-view').htmlView('load', '/html/hd/subscribe.php');
        });

        $(document).on('click', '.geofs-startTrial', (event) => {
            $('.geofs-subscribe-view').htmlView('load', '/html/hd/subscribe.php?method=startHDTrial');
        });

        window.subscribeInitialized = true;

    }

    window.executeOnEventDone('deferredload', initSubscribe);

</script>

<style>

    .geofs-ingame .geofs-geofsHDConfirm,
    .geofs-ingame .geofs-purchase-frame,
    .geofs-ingame .geofs-renewNotice {
        display: none;
    }

</style>

<div class="geofs-subscribe-view geofs-payment-view">
    
<div class="geofs-geofsHDConfirm">

    </div><div class="geofs-trial-frame mdl-shadow--2dp"><h5>Try HD, free, for a day!</h5><h6 class="geofs-notification geofs-info"><i class="material-icons">&#xE88E;</i> You must login to start the one day free trial</h6><a style="float: right;" class="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect" href="#" disabled>Start free trial</a><span>Before purchasing a subscription,<br/> try HD aerial imagery <b>free</b> for one day.</span></div>
            <div class="geofs-purchase-frame mdl-shadow--2dp">
                <h5>Purchase a GeoFS HD subscription</h5>
                <h6 class="geofs-notification geofs-info"><i class="material-icons">&#xE88E;</i> You must login before purchasing a subscription.</h6>                <b>1 year GeoFS HD global aerial imagery<br/><span class="geofs-HD-price"></span></b>
            </div>

            <h6 class="geofs-renewNotice" style="text-align: center;"><i>Subscription and trial do <b>not</b> renew automatically.<br/>You can purchase a new subscription after expiration.</i></h6>

    </div>