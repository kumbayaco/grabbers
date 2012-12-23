var debug = true; // 是否是debug模式，debug下输出文件名，导入成功之后不关闭fla文件
var uriDest = "file:///E|/coding/projects/starling/landgrabbers/bin-debug/resources";


var dirJsfl = fl.scriptURI;
dirJsfl = dirJsfl.substring(0, dirJsfl.lastIndexOf("/"));

var dirList = scanDir(dirJsfl + "/assets");
var uriDest = dirJsfl + "/bin-debug/resources";

for (var i = 0; i < dirList.length; i++) {
	
	var doc = fl.createDocument();
	var uri = dirList[i];
	var temp = uri.split("/");
	var fileName = temp[temp.length - 1];
	
	fileList = [];
	itemList = [];
	
	scanFile(uri);
	importToLib(fileList, itemList);
	
	fl.trace("export " + uriDest + "/" + fileName + ".swf");
	doc.exportSWF(uriDest + "/" + fileName + ".swf", true);
	//fl.saveDocument(doc, uri + "/" + fileName + ".fla");
	fl.closeDocument(doc, false);
}

//if (fl.documents.length==0)
//	fl.quit();

function scanDir(scanuri)  {
	var file = FLfile.listFolder(scanuri);
	var length = file.length;
	var name = "";
	var ext = "";
	var dirs = [];
	for (var i = 0; i<length; i++) {
		name = scanuri + "/" + file[i];
		if (FLfile.getAttributes(name) == "D") {
			dirs.push(name);
		}
	}
	return dirs;
}


function scanFile(scanuri) {
	var file = FLfile.listFolder(scanuri);
	var length = file.length;
	var name = "";
	var ext = "";

	for (var i = 0; i<length; i++) {
		name = scanuri + "/" + file[i];
		if (FLfile.getAttributes(name) == "D") {
			scanFile(name);
		} else {
			ext = name.substr(name.length-3, name.length).toLowerCase();
			if(ext == "jpg" || ext == "png" || ext == "gif" || ext == "mp3"){
				fileList.push(name);
				itemList.push(file[i]);
			}
		}
	}
}

function importToLib(fdata, fitem) {
	var dom = fl.getDocumentDOM();
	var lib = dom.library;
	var itemName = "";
	var i = 0;
	var index = -1;
	var item;
	
	for (i = 0; i<fdata.length; i++) {
		dom.importFile(fdata[i], true);

		index = lib.findItemIndex(fitem[i]);
		item = lib.items[index];
		if (debug) {
			fl.trace("import " + fdata[i]);
		}
		itemName = fdata[i].replace(uri + "/", "").replace("/", "_");
		itemName = itemName.substr(0, itemName.length - 4);
		item.name = itemName;
		item.linkageExportForAS = true;
		item.linkageExportForRS = true;
		item.linkageExportInFirstFrame = true;
		item.linkageClassName = itemName;
	}
}

function writeDocClass(fdata, fname) {
	var temp = "";
	var as = "package{"+"\n"+
			"   import flash.display.Sprite;"+"\n"+
			"   import flash.utils.Dictionary;"+"\n"+
			"   public class Assets extends Sprite{"+"\n"+
			"		public var dic:Dictionary;"+"\n"+
			"		public function Assets(){"+"\n"+
			"			dic = new Dictionary();" + "\n";
	for (var i = 0; i<fdata.length; i++) {
		temp = fdata[i].substr(uri.length+1);
		temp = replaceStr(temp, "/", "_");
		as += "			dic[\"" + temp + "\"] = new " + fname[i] + "(0,0);" + "\n";
	}
	as += 	"		}"+"\n"+
			"	}"+"\n"+
			"}";
	FLfile.write(uri + "/Assets.as", as);
}

function replaceStr(data, preStr, newStr) {
	while (data.indexOf(preStr) != -1) {
		data = data.replace(preStr, newStr);
	}
	return data;
}