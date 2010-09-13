/*var isParser2 = function(){
 var prefs = Components.classes["@mozilla.org/preferences-service;1
"].getService(Components.interfaces.nsIPrefService);
 var branch = prefs.getBranch("extensions.ubiquity.");
 return (branch.getPrefType("parserVersion") != 0) ?
branch.getIntPref("parserVersion") == 2 : false;

}

if (isParser2()) {*/
 /* Parser 2 version of the CmdUtils.CreateCommand calls here */
	CmdUtils.CreateCommand({
	  names: ['shorten'],
	  icon: "http://u.pilsch.com/favicon.png",
	  homepage: "http://u.pilsch.com",
	  author: { name: "Andrew Pilsch (based on code by Arun Shivaram)", email: "andrew@pilsch.com"},
	  license: "GPL",
	  description: "Shortens the selected URL using u.pilsch.com",
	  help: "shorten <long url>",
	  arguments: [ {role: 'object', nountype: noun_arb_text, label: 'longurl'} ],
	  preview: function( pblock, args ) {
	       pblock.innerHTML = _("Replaces the selected URL with a u.pilsch.com URL");
	       this._shorturl(pblock,args.object,"preview");
	  },
	  execute: function(object, args) {
	    this._shorturl("",args.object,"execute");
	  },

	  _shorturl: function( pblock,lurl,call ) {
	    var baseUrl = "http://u.pilsch.com/api-create?url=" + lurl.text;
	    //var params = {longurl: lurl.text};
		var params = {}
	    jQuery.get( baseUrl, params,function(sUrl){
	      if (call=="preview"){
	        pblock.innerHTML = _("Replaces the selected URL with "+sUrl);
	      }
	      if (call=="execute"){
	        CmdUtils.setSelection(sUrl);
	        CmdUtils.copyToClipboard(sUrl);
	      }
	    })

	  }

	});
 /* ... */
/*} else {
	CmdUtils.CreateCommand({
	  name: "shorten",
	  icon: "http://is.gd/favicon.ico",
	  homepage: "http://u.pilsch.com",
	  author: { name: "Andrew Pilsch (based on code by Arun Shivaram)", email: "andrew@pilsch.com"},
	  license: "GPL",
	  description: "Shortens the selected URL using u.pilsch.com",
	  help: "shorten <long url>",
	  takes: {"longurl": noun_arb_text},
	  preview: function( pblock, lurl ) {
	       pblock.innerHTML = "Replaces the selected URL with a u.pilsch.com URL";
	       this._shorturl(pblock,lurl,"preview");
	  },
	  execute: function(lurl) {
	    this._shorturl("",lurl,"execute");
	  },

	  _shorturl: function( pblock,lurl,call){
	    var baseUrl = "http://u.pilsch.com/api-create/" + lurl.text;
	    //var params = {longurl: lurl.text};
		var params = {}
	    jQuery.get( baseUrl, params,function(sUrl){
	      if (call=="preview"){
	        pblock.innerHTML = "Replaces the selected URL with "+sUrl;
	      }
	      if (call=="execute"){
	        CmdUtils.setSelection(sUrl);
	        CmdUtils.copyToClipboard(sUrl);
	      }
	    })

	  }

	});
}*/