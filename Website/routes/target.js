var mysql = require('mysql');

var database = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE
});

database.connect(function(error) {
    if(!!error) {
        console.log('[Monitor]  Error connecting to Database');
        console.log(error);
    } else {
        console.log('[Monitor]  Connected to Database');
    }

    //check_complete(0);

    /*/when db connect, if monitor isnt running monitor[x] == 0, spin up monitor function
    if(!monitor[0])
    {
        check_complete(0);
    }
    if(!monitor[1])
    {
        check_complete(1);
    }
    */
})


async function getDepth(flumeNumber) {
    if (flumeNumber == 0) {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 0 ORDER BY Ddate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Depth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    } else {
        return new Promise((resolve, reject) => {
            try {
                database.query('SELECT * FROM `depth_data` WHERE Depth_Flume_Name = 1 ORDER BY Ddate DESC LIMIT 1',(error, results) => {
                    if(results.length < 1) resolve("error");
                    resolve(results[0].Depth);
                });
            } catch (error) {
                resolve("error");
            }
        })
    }
    resolve("error");
}

var monitor = [0, 0];
var CHECK_DB_INTERVAL = 10000;          //amount of time in ms to wait before checking for target fill

function sleep(ms)
{
    return new Promise(resolve => setTimeout(resolve, ms));
}

//looping function for monitoring a fill target
this.check_complete = async function check_complete(flumeNumber)
{
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Starting...");
            break;
        case 1:
            console.log("[Monitor][LWF] Starting...");
            break;
    }

    //mutex-ish lock to prevent an army of monitor funcs
    monitor[flumeNumber] = 1;
    while(monitor[flumeNumber] == 1)
    {
        var check = await isComplete(flumeNumber);
        switch (check)
        {
            case 1:
                monitor[flumeNumber] = 0;
                    console.log("ending");
                break;
            case -1:
                console.log("monitor spun up with wrong flume number")
                break;
            default:
                //console.log(flumeNumber + " not yet complete");
                break;
        }

        //wait interval before checking again
        await sleep(CHECK_DB_INTERVAL);
    }
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Ended");
            break;
        case 1:
            console.log("[Monitor][LWF] Ended");
            break;
    }
}

async function check_complete(flumeNumber)
{
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Starting...");
            break;
        case 1:
            console.log("[Monitor][LWF] Starting...");
            break;
    }

    //mutex-ish lock to prevent an army of monitor funcs
    monitor[flumeNumber] = 1;
    while(monitor[flumeNumber] == 1)
    {
        var check = await isComplete(flumeNumber);
        switch (check)
        {
            case 1:
                monitor[flumeNumber] = 0;
                    console.log("ending");
                break;
            case -1:
                console.log("monitor spun up with wrong flume number")
                break;
            default:
                //console.log(flumeNumber + " not yet complete");
                break;
        }

        //wait interval before checking again
        await sleep(CHECK_DB_INTERVAL);
    }
    switch (flumeNumber)
    {
        case 0:
            console.log("[Monitor][DWB] Ended");
            break;
        case 1:
            console.log("[Monitor][LWF] Ended");
            break;
    }
}

async function isComplete(flumeNumber) {
    if(flumeNumber != 0 && flumeNumber != 1)
    {
        return -1;
    }
    switch (flumeNumber)
    {
        case 0:
            var current_depth = await getDepth(flumeNumber);

            //check for if therer is a 
            database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 and isComplete = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                if(error) throw error;
                if(results < 1)
                {
                    //no planned fill target
                    return 1;
                }
                else
                {
                    //planned target fill, now check if current level meets target level
                    database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                        if (error) throw error;
                        if(results[0].Tdepth > current_depth)
                        {
                            //not complete
                            console.log("[Monitor][DWB] " + current_depth + " ==> " + results[0].Tdepth);
                        }
                        else if(results[0].Tdepth <= current_depth)
                        {
                            //already complete
                            console.log("[Monitor][DWB] Fill target: " + results[0].Tdepth + " complete");

                            var update_high = results[0].Tdepth + .01;
                            var update_low = results[0].Tdepth - .01;

                            database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdepth > ? AND Tdepth < ?', [update_low, update_high], (error, results) => {
                                if(error) throw error;
                            });
                            
                            //return loop exit response
                            monitor[0] = 0;
                        }
                    });
                }
            });
            break;
        case 1:
            var current_depth = await getDepth(flumeNumber);
            database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 AND isComplete = 0 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                if(error) throw error;
                if(results < 1)
                {
                    //no planned fill target
                    return 1;
                }
                else
                {
                    //planned target fill, now check if current level meets target level
                    database.query('SELECT * FROM `target_depth` WHERE Tdate < CURRENT_TIMESTAMP AND Target_Flume_Name = 1 ORDER BY Tdate DESC LIMIT 1',(error, results) => {
                        if (error) throw error;
                        if(results[0].Tdepth > current_depth)
                        {
                            //not complete
                            console.log("[Monitor][LWF] " + current_depth + " ==> " + results[0].Tdepth);
                        }
                        else if(results[0].Tdepth <= current_depth)
                        {
                            //already complete
                            console.log("[Monitor][LWF] Fill target: " + results[0].Tdepth + " complete");

                            var update_high = results[0].Tdepth + .01;
                            var update_low = results[0].Tdepth - .01;

                            database.query('UPDATE target_depth SET isComplete = 1 WHERE Tdepth > ? AND Tdepth < ?', [update_low, update_high], (error, results) => {
                                if(error) throw error;
                            });
                            
                            //return loop exit response
                            monitor[1] = 0;
                        }
                    });
                }
            });
            break;
    }
    return 0;
}