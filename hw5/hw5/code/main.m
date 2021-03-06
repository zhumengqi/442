% Step 1: Prepare all the params for train
% 1.1 Model
addpath pcode;
zlayer = [init_layer('conv',struct('filter_size',2,'filter_depth',3,'num_filters',2))
	init_layer('pool',struct('filter_size',2,'stride',2))
	init_layer('relu',[])
	init_layer('flatten',struct('num_dims',4))
	init_layer('linear',struct('num_in',32,'num_out',10))
	init_layer('softmax',[])];
model = init_model(zlayer,[10 10 3],10,true);  % 这里的数字需要改么？怎么改？
% 1.2 Input and label
load_MNIST_data;
input = train_data; label = train_label;
lr = 0.01; wd = 0.0005; batchsize = 128;
% 1.3 params and numIters
params = struct('learning_rate',lr,'weight_decay',wd,'batch_size',batchsize);
numIters = 300;
% Step 2: Train the model
[trained_model, loss] = train(model,input,label,params,numIters);
% Step 3: Calculate the accuracy







