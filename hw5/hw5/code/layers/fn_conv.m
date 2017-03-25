% ----------------------------------------------------------------------
% input: in_height x in_width x num_channels x batch_size
% output: out_height x out_width x num_filters x batch_size
% hyper parameters: (stride, padding for further work)
% params.W: filter_height x filter_width x filter_depth x num_filters
% params.b: num_filters x 1
% dv_output: same as output
% dv_input: same as input
% grad.W: same as params.W
% grad.b: same as params.b
% ----------------------------------------------------------------------

function [output, dv_input, grad] = fn_conv(input, params, hyper_params, backprop, dv_output)

[in_height,in_width,num_channels,batch_size] = size(input);
[filter_height,filter_width,filter_depth,num_filters] = size(params.W);
assert(filter_depth == num_channels, 'Filter depth does not match number of input channels');

out_height = size(input,1) - size(params.W,1) + 1;
out_width = size(input,2) - size(params.W,2) + 1;
output = zeros(out_height,out_width,num_filters,batch_size);
% TODO: FORWARD CODE
temp = zeros(out_height, out_width, filter_depth);
for i=1:batch_size
    for j = 1:num_filters
        for n = 1:filter_depth
            temp(:,:,n) = conv2(input(:,:,n,i),params.W(:,:,n,j),'valid');
        end
        output(:,:,j,i) = sum(temp,3) + params.b(j);
    end
end


dv_input = [];
grad = struct('W',[],'b',[]);

if backprop
	dv_input = zeros(size(input));
	grad.W = zeros(size(params.W));
	grad.b = zeros(size(params.b));
	% TODO: BACKPROP CODE
   temp = zeros(in_height, in_width, num_filters);
for i=1:batch_size
    for j = 1:filter_depth
        for n = 1:num_filters
            temp(:,:,n) = conv2(dv_output(:,:,n,i),rot90(params.W(:,:,j,n),2),'full');
        end
        dv_input(:,:,j, i) = sum(temp,3);
    end
end
temp = zeros(filter_height, filter_width, batch_size);
for i = 1:filter_depth
    for j = 1:num_filters
        for n = 1:batch_size
            temp(:,:,n) = conv2(rot90(input(:,:,i,n),2),dv_output(:,:,j,n),'valid');
        end
        grad.W(:,:,i,j) = sum(temp,3);
    end
end
temp =zeros(1,batch_size);
for i = 1:num_filters
    for j = 1:batch_size
        temp2 = dv_output(:,:,i,j);
        temp(1,j) = sum(temp2(:));
    end
    grad.b(i) = sum(temp);
end


end
