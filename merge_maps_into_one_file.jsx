// var colorSpace = NewDocumentMode.RGB; // RGB
var colorSpace = NewDocumentMode.GRAYSCALE; // Grayscale

var bitType = BitsPerChannelType.SIXTEEN; // 16 bit
// var bitType = BitsPerChannelType.EIGHT; // 8 bit

function placeFile(placeFile, offset) {

    var desc21 = new ActionDescriptor();
    desc21.putPath( charIDToTypeID('null'), new File(placeFile) );
    desc21.putEnumerated( charIDToTypeID('FTcs'), charIDToTypeID('QCSt'), charIDToTypeID('Qcsa') );
    var desc22 = new ActionDescriptor();
    desc22.putUnitDouble( charIDToTypeID('Hrzn'), charIDToTypeID('#Pxl'), -25344.000000 + offset[0]);
    desc22.putUnitDouble( charIDToTypeID('Vrtc'), charIDToTypeID('#Pxl'), 25344.000000 - offset[1]);
    desc21.putObject( charIDToTypeID('Ofst'), charIDToTypeID('Ofst'), desc22 );
    executeAction( charIDToTypeID('Plc '), desc21, DialogModes.NO );
    app.refresh();

};

function offset(x, y) {
    var imageSize = 1024;
    return [x * imageSize, y * imageSize];
}

var inputFolder = Folder.selectDialog("Select folder of source images");
if (inputFolder) {
    var docName = inputFolder.toString().split('/');
    docName = docName[docName.length - 1];
    var newFile = app.documents.add(67584, 67584, 72, docName, colorSpace);
    newFile.bitsPerChannel = bitType;
    // var filesArray = inputFolder.getFiles();
    for (var x = -6; x < 60; x++) {
        for (var y = -6; y < 60; y++) {
            var fileObj = File(inputFolder.fullName.concat('/', docName, '_', x, '_', y, '.tga'));
            placeFile(fileObj, offset(x + 6, y + 6));
        };
    };
} else {
    alert('Please, select folder');
};