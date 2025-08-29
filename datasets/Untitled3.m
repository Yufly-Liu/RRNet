clc;
clear;
[fullRows,fullCols] = split_image('D:\LIUYUFEI\code\rrnet-based-on-sunet\data\RRNetDataset\Ra0.8\angle1\7(#)\train\7.bmp', 'D:\LIUYUFEI\code\SUNet-main\test\', 512);
combine_tiles('D:\LIUYUFEI\code\SUNet-main\test\', 'reconstructed_image.png', [512,512],fullRows,fullCols);