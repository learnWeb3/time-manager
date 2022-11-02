const { join } = require('path')
const isProd = process.env.NOD_ENV === "production"

if (!isProd) {
    require('dotenv').config({
        path: join(process.cwd(), '.env')
    })
}


export default {
    "name": "Time manager",
    "slug": "Time manager",
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
        }
    },
    "web": {
        "favicon": "./assets/time_manager_favicon.png"
    },
    "extra": {
        "API_BASE_URL": process.env.API_BASE_URL,
        "LOCAL_STORAGE_CURRENT_USER_KEY": process.env.LOCAL_STORAGE_CURRENT_USER_KEY
    }
}