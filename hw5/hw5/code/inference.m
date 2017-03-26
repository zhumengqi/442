function [output,activations] = inference(model,input)
% Do forward propagation through the network to get the activation
% at each layer, and the final output

num_layers = numel(model.layers);
activations = cell(num_layers,1);

% TODO: FORWARD PROPAGATION CODE
[activations{1},~,~] = model.layers(1).fwd_fn(input,model.layers(1).params,model.layers(1).hyper_params,false,0);
for i = 1:num_layers-1
    [activations{i+1},~,~] = model.layers(i+1).fwd_fn(activations{i},model.layers(i).params,model.layers(i).hyper_params,false,0);
end
% END TODO
output = activations{end};
