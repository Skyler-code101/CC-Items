
## Info
This Is The Shop Used On the Stargate : Releveled Server
## API
The Host Command Runs On Tables
All Tables Consist Of A `functionCall` Value

Functions
```groovy
SetMode
[
    Function Table Setup
    {
        functionCall = "SetMode"
        mode = (int{Use GetModes To Find Modes})
    }
    Reply
    {
        functionCall = "Reply"
        replyType = "print"
        data = (string{Reply Value})
    }
    About
        This Function Sets The Primary Mode For The Device
]
GetModes
[
    Function Table Setup
    {
        functionCall = "GetModes"
    }
    Reply
    {
        functionCall = "Reply"
        replyType = "print"
        data = (string{Mode List})
    }
    About 
        This Function Reads The Mode List On Host
]
Run(Exchange)
[
    Requirement
        A Mode Value Higher Than 0
    Function Table Setup
    {
        functionCall = "Run"
        runningFunc = "Exchange"
        info = {
            id = (int{Account ID})
            pin = (int{Account Pin})
        }
    }
    Reply
    {
        functionCall = "Reply"
        replyType = "Auth"
        data = (bool{Whether This Exchange Succeeded})
    }
    About 
        This Function Runs A Exchange
]
SetCharge
[
    Function Table Setup
    {
        functionCall = "SetCharge"
        value = (int{Amount Charged Or Sold To The Player})
    }
]
```