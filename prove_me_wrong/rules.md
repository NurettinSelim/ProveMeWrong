{
  "rules": {
    ".read": false,
    ".write": false,
    
    "users": {
      "$uid": {
        ".read"  : "auth.uid === $uid", 
        ".write" : "auth.uid === $uid",
        "rating": 
        	{
          	"total": {},
            "count": {},
            "score": {}
        	},
        "score" : {".validate" : "((!data.exists() && newData.val() == 0) || newData.val() - data.val() == 1 || newData.val() - data.val() == -1 )"},
        "rooms": {
          ".write": "auth.uid == $uid && newData.exists()",
          "$id": {
            ".validate": "(root.child('rooms').child(newData.val()).child('ownerID').val() == auth.uid || root.child('rooms').child(newData.val()).child('guestID').val() == auth.uid)"
          }
        },
        "roomCount": {".validate": "auth.uid == $uid && newData.val() <= 7 && (!data.exists() || newData.val() - data.val() == 1 || newData.val() - data.val() == -1 )"},
        "reportScore" : {
          ".read" : "auth.uid != null",
          ".write": "auth.uid != null && (data.exists() ? newData.val() - data.val() <= 16 : newData.val() <= 16) && newData.val() > 0" 
        },
        "reports" : {
          ".read" : false,
          "$reportID" : {
            ".write" : "auth.uid != null && auth.uid != $uid && !root.child('users').child(auth.uid).child('reportedUsers').child($uid).exists() && newData.hasChild('roomID')",
            "isMessage" : {".validate" : "newData.isBoolean()"},
            "message" : {".validate" : "newData.isString()  && newData.exists()"},
            "title" : {".validate" : "newData.isString()    && newData.exists()"},
            "category" : {".validate" : "newData.isString() && newData.exists()"},
            "roomID" : {".validate" : "(newData.isString()  && newData.exists()) && (root.child('rooms').child(newData.val()).child('ownerID').val() == $uid || root.child('rooms').child(newData.val()).child('guestID').val() == $uid)"},
            "messageID" : {".validate" : "newData.isString() && (root.child('rooms').child(newData.parent().child('roomID').val()).child('messages').child(newData.val()).child('message').val() == newData.parent().child('message').val())"},
          }
        },
        "reportedUsers" : {
          "$userID" : {
            "reported" : {".validate" : "newData.isBoolean()"},
          }
        },
        "$other" : {".validate": false},
        
      },
      ".indexOn" : "reportScore",
    },
    
    "rooms": {
      ".read": true,
      "$roomId": {
        ".read": true,
        "ownerID": {
          ".write": "auth.uid != null && !data.exists() && newData.val() == auth.uid",
          ".validate": "newData.val() == auth.uid"
        },
        "guestID": {
          ".write": "auth.uid == newData.val() && !data.exists()",
          ".validate": "newData.val() == auth.uid"
        },
        "ownerScore": {
          ".write": "auth.uid != null && !data.exists()",
          ".validate": "newData.isNumber()"
        },
        "category": {
          ".write": "auth.uid != null && !data.exists()",
          ".validate": "newData.isString() && newData.val().length <= 10"
        },
        "language": {
          ".write": "auth.uid != null && !data.exists()",
          ".validate": "newData.isString() && newData.val().length <= 10"
        },
        "title": {
          ".write": "auth.uid != null && !data.exists()",
          ".validate": "newData.isString() && newData.val().length <= 100"
        },
        
        "messages":{
          ".read": "auth.uid != null && (root.child('rooms').child($roomId).child('ownerID').val() == auth.uid || root.child('rooms').child($roomId).child('guestID').val() == auth.uid)",
          ".write": "auth.uid != null && (root.child('rooms').child($roomId).child('ownerID').val() == auth.uid || root.child('rooms').child($roomId).child('guestID').val() == auth.uid)",
          "$messageId": {
            ".validate": "newData.hasChildren(['message', 'timeStamp', 'senderId']) && newData.child('senderId').val() == auth.uid",
            "message": {".validate": "newData.isString() && newData.val().length > 0 && newData.val().length <= 1000"},
            "timeStamp": {".validate": "newData.isNumber()"},
            "senderId": {".validate": "newData.val() == auth.uid"}
          },
        },
        "$other": {
          ".write": "auth.uid != null && (data.parent().child('ownerID').val() == auth.uid || data.parent().child('guestID').val() == auth.uid) && !newData.exists()",
          ".validate": false
        }
      }
    },
    
    "categories": {
      ".read" : true,
      "$category": {
        
        "$roomID": {
          ".read": true,
          ".write": "auth.uid == root.child('rooms').child($roomID).child('ownerID').val()",
          "timeStamp": {".validate": "newData.isNumber()"},
          
      	},
        ".indexOn": "timeStamp",
      }
    }
    
  }
}
