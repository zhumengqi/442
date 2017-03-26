function [grad] = calc_gradient(model, input, activations, dv_output)
% Calculate the gradient at each layer, to do this you need dv_output
% determined by your loss function and the activations of each layer.
% The loop of this function will look very similar to the code from
% inference, just looping in reverse.

num_layers = numel(model.layers);
grad = cell(num_layers,1);

% TODO: Determine the gradient at each layer with weights to be updated
[~,dv_input{num_layers},grad{num_layers}] = model.layers(num_layers).fwd_fn(activations{num_layers-1},...
    model.layers(num_layers).params,model.layers(num_layers).hyper_params, true, dv_output);
for i = num_layers-1:-1:2
    [~,dv_input{i},grad{i}] = model.layers(i).fwd_fn(activations{i-1},model.layers(i).params,...
        model.layers(i).hyper_params, true, dv_input{i+1});
end
[~,dv_input{1},grad{1}] = model.layers(i).fwd_fn(input, model.layers(1).params,...
    model.layers(1).hyper_params, true, dv_input{1});
