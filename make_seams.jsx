function makeSelection(posX, posY, width, height, offset) {
    var sel = app.activeDocument.selection;
    sel.select([[posX, posY],
                                         [posX, posY + height],
                                         [posX + width, posY + height],
                                         [posX + width, posY]]);
    sel.copy();
    var tempSeam = doc.paste();
    tempSeam.translate(offset[0], offset[1]);
    tempSeam.merge();
}

var doc = app.activeDocument;
var width = parseInt(doc.width);
var height = parseInt(doc.height);

var mapSize = 1024;
var seamSize = 1; // seam size in pixels

var xAmount = Math.floor(width / mapSize);
var yAmount = Math.floor(height / mapSize);

for (var yTile = 0; yTile < yAmount; yTile++) {
    // repeat x one line
    for (var xTile = 0; xTile < xAmount - 1; xTile++) {
        makeSelection(mapSize * (xTile + 1) - seamSize, height - mapSize * (yTile + 1), seamSize, mapSize, [seamSize, 0]);
    };

    if (yTile + 1 < yAmount) {
        // repeat y one line
        for (var xTile = 0; xTile < xAmount; xTile++) {
            makeSelection(mapSize * xTile, height - mapSize * (yTile + 1), mapSize, seamSize, [0, -seamSize]);
        };
    };
};

doc.save();