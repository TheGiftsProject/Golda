var running = false;
chrome.browserAction.onClicked.addListener(function(tab) {
  // Send a request to the content script.
  if (running) return;
  running = true;
  chrome.tabs.sendRequest(tab.id, {action: "startModalAction"});
  chrome.tabs.sendRequest(tab.id, {action: "getDOM"}, function(response)
  {
    var dom = $(response.dom);
    var form = dom.find("#iform")[0];
    var data = {};

    for (var i = 0; form[i] != undefined; ++i) {
        data[form[i].name] = form[i].value;
    }

    data.moedChiuv = dom.find("#selectedDate").find("option[selected]").eq(0).text().replace('/', '');

    var transactionList = getTransactionList(dom);

    function send(count) {
        getDetailsDom(tab, data, transactionList[count]).done(function (result) {
            //console.dir(parseDetails($(result)));
            if (result) {
                $.ajax("http://192.168.2.29:3000/import", { data: parseDetails($(result)), dataType: 'json', type: "POST"})
            }
            if (count < transactionList.length) {
                chrome.tabs.sendRequest(tab.id, {action: "updateProgress", progress: count/transactionList.length});
                setTimeout(function() { send(count+1); }, 300);
            } else {
                chrome.tabs.sendRequest(tab.id, {action: "endModalAction"});
                running = false;
            }
        });
    }

    send(0);
  });
});

function getTransactionList(dom) {
    var params = [];
    dom.find("a[href*='javascript:showDealDetailsInbound']").each( function() {
        var paramsArray = $(this).attr('href').match(/\('([^']+)',\s?'([^']*)'\)/);
        paramsArray.shift();
        params.push(paramsArray);
    });
    return params;
}

function getDetailsDom(tab, data, transactionParams) {
    var deferred = $.Deferred();
    if (transactionParams == undefined || transactionParams == null) {
        deferred.resolve(null);
        return deferred.promise();
    }
    var params = {
        perutNosaf: transactionParams[1],
        shovarRatz: transactionParams[0],
        inState: "yes",
        showAsFile: '0',
        transactionId: "PirteyIska_204",
        previousTxName: "DealsListForDate_203",
        reqName: "action",
        direction: "0"
    };
    var postParams = $.extend({}, data, params);


    chrome.tabs.sendRequest(tab.id, {postParams: postParams, action: "getDetails"}, function(response) {
        deferred.resolve(response.dom);
    });

    return deferred.promise();
}

function parseDetails(dom) {
    var valueFields = dom.find(".DetailsTD");
    //return { 
        //txnId: '123123123',
        //supplierName: 'Sakin enterprisers',
        //sector: 'asdfasdf',
        //address: 'Rostchinl 13', 
        //date:'03/12/2011', 
        //time: '12:00',
        //sum: 12
        //}
    return {
        txnId: dom.find("#shovarRatz").val(),
        supplierName: getValueFromField(valueFields, "supplierName"),
        sector: getValueFromField(valueFields, "sector"),
        address: getValueFromField(valueFields, "address"),
        date: getValueFromField(valueFields, "purchaseDateOutboundIsracard"),
        time: getValueFromField(valueFields, "purchaseTime"),
        sum: getValueFromField(valueFields, "dealSum")
    };
}

function getValueFromField(fields, name) {
    var find = fields.filter("[headers*='" + name + "']");
    var eq = find.eq(0);
    var match = eq.text().match(/\S+/g);
    return (match == null || match == undefined ? "" : match.join(' '));
}
