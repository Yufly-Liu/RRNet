function [fullRows,fullCols] = split_image(inputImagePath, outputDir, tileSize)
% SPLIT_IMAGE_WITH_DISCARD 分割图像为多个不重叠的tile，并丢弃不能整除的部分
%
% 输入:
%   inputImagePath - 原始图像路径
%   outputDir      - 输出目录
%   tileSize       - 每个 tile 的大小 (默认 256)

    if nargin < 3 || isempty(tileSize)
        tileSize = 512;
    end

    % 创建输出文件夹
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % 读取图像
    img = imread(inputImagePath);

    % 获取图像尺寸
    [rows, cols, ~] = size(img);

    % 计算能够被整除的行数和列数
    fullRows = floor(rows / tileSize) * tileSize;
    fullCols = floor(cols / tileSize) * tileSize;

    tileCount = 0;

    % 分割图像并忽略边缘
    for r = 1:tileSize:fullRows-tileSize+1
        for c = 1:tileSize:fullCols-tileSize+1
            tile = img(r:r+tileSize-1, c:c+tileSize-1, :);
            tileCount = tileCount + 1;
            filename = fullfile(outputDir, sprintf('tile_%04d.bmp', tileCount));
            imwrite(tile, filename);
        end
    end

    fprintf('成功分割图像，共生成 %d 张 %d×%d 小图。\n', tileCount, tileSize, tileSize);
end