clc
clear 
close all

train_path = 'D:\LIUYUFEI\code\SUNet-main\datasets\Interreflection\';% 影象資料夾路徑 最後記得加\
tg_path = 'D:\LIUYUFEI\code\SUNet-main\datasets\FakeGT\';
target_path = 'D:\LIUYUFEI\code\SUNet-main\datasets\InterreflectionRemoval\train\target\';
input_path = 'D:\LIUYUFEI\code\SUNet-main\datasets\InterreflectionRemoval\train\input\';
img_path_list = dir(strcat(tg_path,'*.bmp'));%獲取該資料夾中所有jpg格式的影象
img_num = length(img_path_list);%獲取影象總數量
count = 0;
% 定义感兴趣区域 (ROI) 的边界
x_min = 300; % 左边界
y_min = 100; % 上边界
x_max = 1800; % 右边界
y_max = 1300; % 下边界
figure;
image = imread("D:\LIUYUFEI\code\SUNet-main\datasets\Interreflection\090.bmp");
imshow(image); % 显示原始图像
image_name = img_path_list(1).name;
hold on;
rectangle('Position', [x_min, y_min, x_max-x_min, y_max-y_min], 'EdgeColor', 'r', 'LineWidth', 2); % 在图像上画出 ROI
title(['Image with ROI: ', image_name]);
hold off;

if img_num > 0 % 如果有符合条件的图像

    
    % 确保裁剪尺寸不会超出 ROI 边界
    a = 511; % 裁剪宽度
    b = 511; % 裁剪高度
    c = 5;
    for j = 1:img_num
        image_name = img_path_list(j).name;
        
        % 读取输入和目标图像
        input = imread(fullfile(train_path, image_name));
        target = imread(fullfile(tg_path, image_name));
        
        [Y, X, ~] = size(input); % 获取图像尺寸
        
        % 确保 ROI 在图像范围内
        if x_min < 1 || y_min < 1 || x_max > X || y_max > Y
            warning('ROI 超出图像范围，跳过此图像 %s', image_name);
            continue;
        end
        
        for c_img_num = 1:c
            % 在 ROI 内随机选择裁剪起点
            y = randi([y_min, y_max - b]);
            x = randi([x_min, x_max - a]);
            
            % 确保裁剪不会超出图像边界
            if x + a > X || y + b > Y
                warning('裁剪区域超出图像边界，跳过此次裁剪');
                continue;
            end
            
            % 执行裁剪
            C = imcrop(input, [x y a b]);
            R = imcrop(target, [x y a b]);
            
            count = count + 1;
            imwrite(C, fullfile(input_path, sprintf('%d.bmp', count)));
            imwrite(R, fullfile(target_path, sprintf('%d.bmp', count)));
        end
        
        fprintf('已处理图像 %d\n', j);
    end
end
fprintf('finished!\n');