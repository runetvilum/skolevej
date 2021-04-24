const puppeteer = require('puppeteer');
var uuid = require('uuid');
var fs = require('fs');
const path = require('path')
var express = require('express');
var app = express();
app.use(express.static(__dirname)); //  "public" off of current is root
app.use(express.json())
var OSRM = require('osrm')

var transport = {
    bicycle: {
        "0-3": new OSRM({ path: path.join(__dirname, "../bicycle/Skolevej_0-3.osrm"), algorithm: 'MLD' }),
        "4-6": new OSRM({ path: path.join(__dirname, "../bicycle/Skolevej_4-6.osrm"), algorithm: 'MLD' }),
        "7-10": new OSRM({ path: path.join(__dirname, "../bicycle/Skolevej_7-10.osrm"), algorithm: 'MLD' }),
        "all": new OSRM({ path: path.join(__dirname, "../bicycle/Vejmidte.osrm"), algorithm: 'MLD' })
    },
    car: {
        "0-3": new OSRM({ path: path.join(__dirname, "../car/Skolevej_0-3.osrm"), algorithm: 'MLD' }),
        "4-6": new OSRM({ path: path.join(__dirname, "../car/Skolevej_4-6.osrm"), algorithm: 'MLD' }),
        "7-10": new OSRM({ path: path.join(__dirname, "../car/Skolevej_7-10.osrm"), algorithm: 'MLD' }),
        "all": new OSRM({ path: path.join(__dirname, "../car/Vejmidte.osrm"), algorithm: 'MLD' })
    },
    foot: {
        "0-3": new OSRM({ path: path.join(__dirname, "../foot/Skolevej_0-3.osrm"), algorithm: 'MLD' }),
        "4-6": new OSRM({ path: path.join(__dirname, "../foot/Skolevej_4-6.osrm"), algorithm: 'MLD' }),
        "7-10": new OSRM({ path: path.join(__dirname, "../foot/Skolevej_7-10.osrm"), algorithm: 'MLD' }),
        "all": new OSRM({ path: path.join(__dirname, "../foot/Vejmidte.osrm"), algorithm: 'MLD' })
    }
};
/*
var transport = {
    bicycle: {
        "0-3": new OSRM({ path: "bicycle/Skolevej_0-3.osrm" }),
        "4-6": new OSRM({ path: "bicycle/Skolevej_4-6.osrm" }),
        "7-10": new OSRM({ path: "bicycle/Skolevej_7-10.osrm" }),
        "all": new OSRM({ path: "bicycle/Vejmidte.osrm" })
    },
    car: {
        "0-3": new OSRM({ path: "car/Skolevej_0-3.osrm" }),
        "4-6": new OSRM({ path: "car/Skolevej_4-6.osrm" }),
        "7-10": new OSRM({ path: "car/Skolevej_7-10.osrm" }),
        "all": new OSRM({ path: "car/Vejmidte.osrm" })
    },
    foot: {
        "0-3": new OSRM({ path: "foot/Skolevej_0-3.osrm" }),
        "4-6": new OSRM({ path: "foot/Skolevej_4-6.osrm" }),
        "7-10": new OSRM({ path: "foot/Skolevej_7-10.osrm" }),
        "all": new OSRM({ path: "foot/Vejmidte.osrm" })
    }
};
*/
(async () => {
    
  })();

app.get('/pdf/:skole/:klasse/:transport/:retning/:lat/:lng', async (req, res) => {
    try {
        const browser = await puppeteer.launch({
            headless: true,
            args: [
            "--no-sandbox",
            "--disable-gpu",
            ]
        });
        const page = await browser.newPage();
        await page.goto(`http://localhost:5000/print.html#/${req.params.skole}/${req.params.klasse}/${req.params.transport}/${req.params.retning}/${req.params.lat}/${req.params.lng}`, {waitUntil: 'networkidle2'});
        const buf = await page.pdf({format: 'A4'});  
        await browser.close();
        res.setHeader('Content-Length', buf.length);
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename="tilskud.pdf"')
        res.send(buf)
        /*
        res.download(`${uuid.v4()}.pdf`, 'ansøgning.pdf', function () {
            fs.unlink(file);
        });
        */  
    } catch (err) {
        console.log(err);
        res.json(err);
    }  
});
app.post('/route/:transport/:age', function (req, res) {    
    // req.body.geometries = 'geojson'
    transport[req.params.transport][req.params.age].route(req.body, function (err, result) {
        if (err) {
            return res.sendStatus(500);
        }
        res.json(result);
    });
});

app.listen(5000);
console.log('Listening on port 5000');
