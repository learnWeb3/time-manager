const { join } = require('path')
require('dotenv').config({
    path: join(process.cwd(), '.env')
});


export default {
    "name": "time-manager",
    "slug": "time-manager",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/time_manager_icon.png",
    "userInterfaceStyle": "light",
    "splash": {
        "image": "./assets/time_manager_splash.png",
        "resizeMode": "cover",
        "backgroundColor": "#ffffff"
    },
    "updates": {
        "fallbackToCacheTimeout": 0
    },
    "assetBundlePatterns": [
        "**/*"
    ],
    "ios": {
        "supportsTablet": true
    },
    "android": {
        "adaptiveIcon": {
            "foregroundImage": "./assets/time_manager_icon.png",
            "backgroundColor": "#FFFFFF"
        },
        "package": "com.yourcompany.yourappname",
        "versionCode": 1
    },
    "web": {
        "favicon": "./assets/time_manager_favicon.png"
    },
    "extra": {
        "API_BASE_URL": process.env.API_BASE_URL,
        "LOCAL_STORAGE_CURRENT_USER_KEY": process.env.LOCAL_STORAGE_CURRENT_USER_KEY,
        "eas": {
            "projectId": "cec7c697-e61f-41a1-b901-aa4e52aa1001"
        }
    }
}