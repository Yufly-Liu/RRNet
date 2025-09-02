clc;
clear;
% 定义根目录和目标目录
rootDir = 'D:\LIUYUFEI\code\rrnet-based-on-sunet\data\experment\Ra1.2\angle4';      % 如 'D:\data'
targetDir = 'D:\LIUYUFEI\code\SUNet-main\datasets\Interreflection';  % 如 'D:\selected_images'
FakeGtDir = 'D:\LIUYUFEI\code\SUNet-main\datasets\FakeGT';
% 创建目标文件夹（如果不存在）
if ~exist(targetDir, 'dir')
    mkdir(targetDir);
end

if ~exist(FakeGtDir, 'dir')
    mkdir(FakeGtDir);
end
% 初始化全局计数器
globalCounter = 341;

% 遍历文件夹 0 到 10
for folderIdx = 0:10
    % 构建 train 文件夹路径
    trainFolder = fullfile(rootDir, num2str(folderIdx), 'train');
    FakeGTFolder = fullfile(rootDir, num2str(folderIdx), 'tg');
    
    % 确保该文件夹存在
    if ~exist(trainFolder, 'dir')
        warning('文件夹 %s 不存在，跳过。', trainFolder);
        continue;
    end
        % 确保该文件夹存在
    if ~exist(FakeGTFolder, 'dir')
        warning('文件夹 %s 不存在，跳过。', FakeGTFolder);
        continue;
    end
    
    % 获取前40张图像路径：0.bmp 到 39.bmp
    TrainImageFiles = {};
    for imgIdx = 0:39
        imgPath = fullfile(trainFolder, sprintf('%d.bmp', imgIdx));
        if exist(imgPath, 'file')
            TrainImageFiles{end+1} = imgPath;
        else
            error('图像文件 %s 不存在，请检查路径是否正确。', imgPath);
        end
    end
    
        FakeGtImageFiles = {};
    for imgIdx = 0:39
        imgPath = fullfile(FakeGTFolder, sprintf('%d.bmp', imgIdx));
        if exist(imgPath, 'file')
            FakeGtImageFiles{end+1} = imgPath;
        else
            error('图像文件 %s 不存在，请检查路径是否正确。', imgPath);
        end
    end

    % 随机选择10张图像
    selectedIdx = randsample(40, 10, false);  % 不重复抽样
    selectedFiles1 = TrainImageFiles(selectedIdx);
    selectedFiles2 = FakeGtImageFiles(selectedIdx);

    % 复制并重命名为全局自然顺序名
    for i = 1:length(selectedFiles1)
        sourceFile1 = selectedFiles1{i};
        sourceFile2 = selectedFiles2{i};
        
        % 新文件名格式为：img_001.bmp, img_002.bmp, ...
        newName = sprintf('%03d.bmp', globalCounter);
        destFile1 = fullfile(targetDir, newName);
        destFile2 = fullfile(FakeGtDir, newName);
        
        copyfile(sourceFile1, destFile1);
        copyfile(sourceFile2, destFile2);
        
        % 更新全局计数器
        globalCounter = globalCounter + 1;
    end
    
    fprintf('已从文件夹 %d 中复制 10 张图像。\n', folderIdx);
end

disp('所有图像抽取完成，已按自然顺序命名保存！');
