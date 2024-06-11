var World = {
    mealInformation: {
        burger: {
            price: 0.00,
            description: "",
        },
        coffee: {
            price: 0.00,
            description: "",
        },
        sushi: {
            price: 0.00,
            description: "",
        }
    },
    loaded: false,
    mealSettings: {
        burger: {
            scale: 5.0,
            translateX: -1
        },
        coffee: {
            scale: 5.0,
            translateX: -1
        },
        sushi: {
            scale: 4.5,
            translateX: 1
        },
    },

    ngrok: "https://303c-2a02-1810-846f-b100-603e-3757-8a8e-e988.ngrok-free.app/scanningCompetition",

    init: function initFn() {
        var todayDate = new Date().toISOString().slice(0, 10);

        // Send a POST through Dart
        // AR.platform.sendJSONObject({
        //     "name": "Poster opened at " + todayDate,
        //     "id": Date.now().toString()
        // });


        // JS Way of sending a POST
        postJSONObject({
            "name": "Poster opened at " + todayDate,
            "id": Date.now().toString()
        }, World.ngrok);

        this.createOverlays();
    },

    createOverlays: function createOverlaysFn() {
        // get tracker
        this.targetCollectionResource = new AR.TargetCollectionResource("assets/tracker.wtc", {
            onError: World.onError
        });

        // make image tracker
        this.tracker = new AR.ImageTracker(this.targetCollectionResource, {
            maximumNumberOfConcurrentlyTrackableTargets: 4, // a maximum of 4 targets can be tracked simultaneously
            extendedRangeRecognition: AR.CONST.IMAGE_RECOGNITION_RANGE_EXTENSION.OFF,
            onTargetsLoaded: World.showInfoBar,
            onError: World.onError
        });

        // Pre-load models in cache
        new AR.Model("assets/models/burger.wt3");
        new AR.Model("assets/models/coffee.wt3");
        new AR.Model("assets/models/sushi.wt3");

        // We use "*" so that we can have multiple targets
        this.mealTrackable = new AR.ImageTrackable(this.tracker, "*", {

            onImageRecognized: function (target) {

                // Create AR based on target
                var model = new AR.Model("assets/models/" + target.name + ".wt3", {
                    scale: World.mealSettings[target.name].scale,
                    translate: {
                        x: World.mealSettings[target.name].translateX,
                    },
                    rotate: {
                        z: 180
                    },
                    onError: World.onError
                });
                console.log("printed model " + target.name + " at " + Date.now())

                // Create the HTML drawable

                var htmlString = '<body><h1>' + target.name + '</h1><h1>Price:' + World.mealInformation[target.name].price + '</h1><h1>' + World.mealInformation[target.name].description + '</h1></body>'

                var xWeight = World.mealSettings[target.name].translateX * 2.25;
                if (xWeight > 0) {
                    xWeight = 1.3;
                }

                var htmlDrawable = new AR.HtmlDrawable({ html: htmlString }, 1, {
                    backgroundColor: "#FFFFFF",
                    translate: {
                        x: (xWeight),
                        y: 0.5
                    },
                    // onClick: function () {
                    //     AR.platform.sendJSONObject({
                    //         "name": target.name,
                    //         "id": Date.now().toString()
                    //     })
                    // },
                    horizontalAnchor: AR.CONST.HORIZONTAL_ANCHOR.LEFT,
                    verticalAnchor: AR.CONST.VERTICAL_ANCHOR.TOP,
                    opacity: 0.9
                });

                /* Adds the model and HTML drawable as augmentation for the currently recognized target. */
                this.addImageTargetCamDrawables(target, model);
                this.addImageTargetCamDrawables(target, htmlDrawable);
            },
            onError: World.onError,
        });
    },

    onError: function onErrorFn(error) {
        alert(error);
    },

    newData: function newDataFn(meal_information) {
        World.mealInformation = meal_information;
    },
};

World.init();

function postJSONObject(jsonObject, url) {
    console.log(JSON.stringify(jsonObject, null, 2), url);
    fetch(url, {
        method: 'POST',
        headers: {
            'ngrok-skip-browser-warning': 'true',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(jsonObject)
    })
        .then(response => response.json())
        .then(data => {
            console.log('Post request successful:', data);
        })
        .catch(error => {
            console.error("POST NOT WORK!!!!")
            console.error('Error:', error);
        });
}
