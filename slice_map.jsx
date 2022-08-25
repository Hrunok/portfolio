var doc = app.activeDocument;
var baseName = doc.name;
baseName = baseName.split('.')[0];
var destFolder = doc.path.fullName;
var width = parseInt(doc.width);
var height = parseInt(doc.height);

var mapSize = 1024;

var xAmount = Math.floor(width / mapSize);
var yAmount = Math.floor(height / mapSize);

var savedState = app.activeDocument.activeHistoryState;
var targaSaveOptions = new TargaSaveOptions();
targaSaveOptions.alphaChannels = false;

var pngSaveOptions = new PNGSaveOptions();


var folder = new Folder(destFolder.concat('/', baseName));
if (! folder.exists) {
    folder.create();
};

for (var y = 0; y < yAmount; y++) {
    for (var x = 0; x < xAmount; x++) {
        var cropRect = [mapSize * x, height - mapSize * (y + 1), mapSize * (x + 1), height - mapSize * y]; 
        doc.crop(cropRect);
        app.refresh();
        var newFileName = destFolder.concat('/', baseName, '/', baseName, '_', -2 + x, '_', -2 + y, '.tga'); // destination folder + new folder + baseName_x<number>_y<number> + .extension 
        var filename = new File(newFileName);
        app.activeDocument.saveAs(filename, pngSaveOptions, true, Extension.LOWERCASE);
        app.activeDocument.activeHistoryState = savedState;
        app.refresh();
    };
};