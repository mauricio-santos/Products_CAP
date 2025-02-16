sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'de/santos/products/test/integration/FirstJourney',
		'de/santos/products/test/integration/pages/ProductsList',
		'de/santos/products/test/integration/pages/ProductsObjectPage',
		'de/santos/products/test/integration/pages/ReviewsObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('de/santos/products') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
                }
            },
            opaJourney.run
        );
    }
);