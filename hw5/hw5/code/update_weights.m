function updated_model = update_weights(model,grad,hyper_params)

num_layers = length(grad);
a = hyper_params.learning_rate;
lmda = hyper_params.weight_decay;
updated_model = model;

% TODO: Update the weights of each layer in your model based on the calculated gradients
for i = 1:num_layers
    step_size = lmda*a;
    updated_model.layers(i).params.W = updated_model.layers(i).params.W - step_size * grad{i}.W;
    updated_model.layers(i).params.b = updated_model.layers(i).params.b - step_size * grad{i}.b;
end

