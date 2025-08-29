function combine_tiles(inputDir, outputImagePath, tileSize, fullRows , fullCols)
% COMBINE_TILES 将分割的小图块重组为原始图像
%
% 输入:
%   inputDir       - 包含分割后小图块的目录路径
%   outputImagePath- 输出重组图像的文件路径
%   tileSize       - 每个小图块的大小 [height, width]
    fullRows = 2048;
    fullCols = 1280;
    % 读取inputDir目录下的所有png图片
    tileFiles = dir(fullfile(inputDir, '*.bmp'));
    numTiles = length(tileFiles);

    % 假设图块名称按行列顺序排列，例如tile_row_col.png
    % 提取第一个图块以确定其尺寸
    firstTilePath = fullfile(inputDir, tileFiles(1).name);
    firstTile = imread(firstTilePath);
    [~, tileHeight, tileWidth, ~] = size(firstTile); % 获取图块高度和宽度

    % 如果指定了tileSize，则使用指定的大小
    tileHeight = tileSize(1);
    tileWidth = tileSize(2);

    % 计算原图的总尺寸
    numRows = fullCols/tileHeight; % 假设图块数目是行数和列数的平方
    numCols = fullRows/tileWidth;
    
    % 初始化重组图像
    reconstructedImage = uint8(zeros(tileHeight * numRows, tileWidth * numCols, size(firstTile, 3)));

    for idx = 1:numTiles
        % 读取每一个图块
        tilePath = fullfile(inputDir, tileFiles(idx).name);
        tile = imread(tilePath);

        % 计算图块在重组图像中的位置
        rowIdx = floor((idx-1) / numCols);
        colIdx = mod(idx-1, numCols);

        % 将图块放置到重组图像上
        startRow = rowIdx * tileHeight + 1;
        endRow = (rowIdx + 1) * tileHeight;
        startCol = colIdx * tileWidth + 1;
        endCol = (colIdx + 1) * tileWidth;
        reconstructedImage(startRow:endRow, startCol:endCol, :) = tile;
    end

    % 保存重组后的图像
    imwrite(reconstructedImage, outputImagePath);
end