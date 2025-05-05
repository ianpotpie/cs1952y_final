import numpy as np


def sigmoid(x):
    return 1 / (1 + np.exp(-x))


def sigmoid_derivative(x):
    return x * (1 - x)


def forward_pass(input_matrix, weights_matrix, bias_vector):
    
    weighted_sum = np.dot(input_matrix, weights_matrix) + bias_vector
    
    activated_output = sigmoid(weighted_sum)
    return activated_output


def backwards_pass(output_matrix, input_matrix, true_values, weights_matrix, bias_vector, learning_rate=0.01):
    
    loss_deriv = output_matrix - true_values

    
    sigmoid_deriv = sigmoid_derivative(output_matrix)

    
    delta_sigmoid = loss_deriv * sigmoid_deriv

    
    gradient_W = np.dot(input_matrix.T, delta_sigmoid)
    gradient_b = np.sum(delta_sigmoid, axis=0, keepdims=True) 

    
    updated_weights = weights_matrix - learning_rate * gradient_W
    updated_biases = bias_vector - learning_rate * gradient_b

    return updated_weights, updated_biases


def compute_accuracy(predictions, labels):
    predictions = np.round(predictions)  # Convert predictions to binary (0 or 1)
    return np.mean(predictions == labels) * 100 


input_size = 4 
output_size = 1 


np.random.seed(42)
weights = np.random.randn(input_size, output_size) 
bias = np.random.randn(1, output_size)


def train(training_data, training_labels, weights, bias, epochs=100, learning_rate=0.01):
    
    training_data = np.array(training_data)
    training_labels = np.array(training_labels).reshape(-1, 1) 

    for epoch in range(epochs):
        for i in range(len(training_data)):
            input_matrix = training_data[i:i+1] 
            true_values = training_labels[i:i+1]
            
            output = forward_pass(input_matrix, weights, bias)

            
            weights, bias = backwards_pass(output, input_matrix, true_values, weights, bias, learning_rate)
        

    return weights, bias


def test(testing_data, testing_labels, weights, bias):
    testing_data = np.array(testing_data)
    testing_labels = np.array(testing_labels).reshape(-1, 1)

    test_predictions = forward_pass(testing_data, weights, bias)
    test_accuracy = compute_accuracy(test_predictions, testing_labels)

    print(f"Testing Accuracy: {test_accuracy}%")
    return test_accuracy


epochs = 500  
learning_rate = 0.01


training_data = [[5.5,2.4,3.8,1.1],
[5.5,2.4,3.7,1.0],
[5.1,3.5,1.4,0.2],
[4.9,3.0,1.4,0.2],
[4.7,3.2,1.3,0.2],
[4.6,3.1,1.5,0.2],
[6.1,2.8,4.7,1.2],
[6.4,2.9,4.3,1.3],
[5.0,3.6,1.4,0.2],
[5.4,3.9,1.7,0.4],
[5.4,3.0,4.5,1.5],
[4.6,3.4,1.4,0.3],
[5.0,3.4,1.5,0.2],
[4.4,2.9,1.4,0.2],
[5.6,2.9,3.6,1.3],
[4.9,3.1,1.5,0.1],
[5.4,3.7,1.5,0.2],
[6.6,3.0,4.4,1.4],
[6.8,2.8,4.8,1.4],
[6.7,3.0,5.0,1.7],
[6.0,2.9,4.5,1.5],
[5.7,2.6,3.5,1.0],
[4.8,3.4,1.6,0.2],
[4.8,3.0,1.4,0.1],
[4.3,3.0,1.1,0.1],
[5.8,4.0,1.2,0.2],
[5.8,2.6,4.0,1.2],
[5.7,4.4,1.5,0.4],
[5.4,3.9,1.3,0.4],
[5.0,2.3,3.3,1.0],
[5.1,3.5,1.4,0.3],
[5.7,3.8,1.7,0.3],
[5.1,3.8,1.5,0.3],
[5.4,3.4,1.7,0.2],
[5.6,2.7,4.2,1.3],
[5.1,3.7,1.5,0.4],
[4.6,3.6,1.0,0.2],
[5.1,3.3,1.7,0.5],
[7.0,3.2,4.7,1.4],
[6.4,3.2,4.5,1.5],
[6.9,3.1,4.9,1.5],
[4.8,3.4,1.9,0.2],
[5.0,3.0,1.6,0.2],
[5.0,3.4,1.6,0.4],
[6.3,2.5,4.9,1.5],
[5.2,3.5,1.5,0.2],
[5.2,3.4,1.4,0.2],
[6.7,3.1,4.4,1.4],
[5.6,3.0,4.5,1.5],
[5.8,2.7,4.1,1.0],
[6.2,2.2,4.5,1.5],
[5.6,2.5,3.9,1.1],
[5.9,3.2,4.8,1.8],
[6.1,2.8,4.0,1.3],
[4.7,3.2,1.6,0.2],
[4.8,3.1,1.6,0.2],
[6.1,2.9,4.7,1.4],
[5.4,3.4,1.5,0.4],
[5.2,4.1,1.5,0.1],
[5.5,4.2,1.4,0.2],
[6.3,2.3,4.4,1.3],
[5.6,3.0,4.1,1.3],
[5.5,2.5,4.0,1.3],
[5.5,2.6,4.4,1.2],
[6.1,3.0,4.6,1.4],
[4.9,3.1,1.5,0.1],
[5.0,3.2,1.2,0.2],
[6.0,3.4,4.5,1.6],
[6.7,3.1,4.7,1.5],
[5.5,3.5,1.3,0.2],
[4.9,3.1,1.5,0.1],
[5.8,2.7,3.9,1.2],
[6.0,2.7,5.1,1.6],
[4.4,3.0,1.3,0.2],
[5.1,3.4,1.5,0.2],
[5.7,3.0,4.2,1.2],
[5.7,2.9,4.2,1.3],
[6.2,2.9,4.3,1.3],
[5.1,2.5,3.0,1.1],
[5.7,2.8,4.1,1.3]]

training_labels = [1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 
1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1]


testing_data = [[6.3,3.3,4.7,1.6],
[4.9,2.4,3.3,1.0],
[6.6,2.9,4.6,1.3],
[5.0,3.5,1.3,0.3],
[4.5,2.3,1.3,0.3],
[4.4,3.2,1.3,0.2],
[5.0,2.0,3.5,1.0],
[5.9,3.0,4.2,1.5],
[6.0,2.2,4.0,1.0],
[5.0,3.5,1.6,0.6],
[5.1,3.8,1.9,0.4],
[5.5,2.3,4.0,1.3],
[6.5,2.8,4.6,1.5],
[4.8,3.0,1.4,0.3],
[5.7,2.8,4.5,1.3],
[5.1,3.8,1.6,0.2],
[4.6,3.2,1.4,0.2],
[5.3,3.7,1.5,0.2],
[5.2,2.7,3.9,1.4],
[5.0,3.3,1.4,0.2]]

testing_labels = [1,1,1,0,0,0,1,1,1,0,0,1,1,0,1,0,0,0,1,0]




weights, bias = train(training_data, training_labels, weights, bias, epochs, learning_rate)


test_accuracy = test(testing_data, testing_labels, weights, bias)

