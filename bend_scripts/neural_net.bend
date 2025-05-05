
def multiply_lists(list1, list2):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      h1 = list1.head
      t1 = list1.tail
      match list2:
        case List/Nil:
          return List/Nil
        case List/Cons:
          h2 = list2.head
          t2 = list2.tail
          return List/Cons { head: h1 * h2, tail: multiply_lists(t1, t2) }

def multiply_list_by_scalar(list1, scalar):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      h1 = list1.head 
      t1 = list1.tail
      return List/Cons { head: h1 * scalar, tail: multiply_list_by_scalar(t1, scalar) }


def add_lists(list1, list2):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      h1 = list1.head
      t1 = list1.tail
      match list2:
        case List/Nil:
          return List/Nil
        case List/Cons:
          h2 = list2.head
          t2 = list2.tail
          return List/Cons { head: h1 + h2, tail: add_lists(t1, t2) }

def subtract_lists(list1, list2):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      h1 = list1.head
      t1 = list1.tail
      match list2:
        case List/Nil:
          return List/Nil
        case List/Cons:
          h2 = list2.head
          t2 = list2.tail
          return List/Cons { head: u24/to_f24(h1) - u24/to_f24(h2), tail: subtract_lists(t1, t2) }

def add_matrix(A, B, row_index, result_matrix):
  row_A = get_row_at_index(row_index, A)
  row_B = get_row_at_index(row_index, B)
  
  match row_A:
    case List/Nil:
      return result_matrix # Done with matrix addition
    case List/Cons:
      row_sum = add_lists(row_A, row_B) 
      new_matrix = concat(result_matrix, [row_sum]) 
      return add_matrix(A, B, row_index + 1, new_matrix)

def subtract_matrix(A, B, row_index, result_matrix):
  row_A = get_row_at_index(row_index, A)
  row_B = get_row_at_index(row_index, B)
  # return row_A
  match row_A:
    case List/Nil:
      return result_matrix # Done with matrix addition
    case List/Cons:
      row_sum = subtract_lists(row_A, row_B) 
      new_matrix = concat(result_matrix, [row_sum]) 
      # return A
      return subtract_matrix(A, B, row_index + 1, new_matrix)

# combines two lists (l1, l2) from left to right.
concat : (List t) -> (List t) -> (List t) = 
  @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (concat l1.tail l2))
    List/Nil: l2
  }

def get_row(list1, prevoutputs):
  match list1:
    case List/Nil:
      return prevoutputs
    case List/Cons:
      h1 = list1.head
      t1 = list1.tail
      new_outputs = concat(prevoutputs, [h1])
      return get_row(t1, new_outputs)

# List index:
# returns the value of a specific list index i, or * if the index doesn't exist.
index : (List t) -> u24 -> (Result t None) = 
  @l @i
  match l {
    List/Cons: 
      switch i {
        0: (Result/Ok l.head)
        _: (index l.tail (i-1))
      }
    List/Nil: (Result/Err *)
  }

def get_row_at_index(real_index, list1):
  row = index(list1, real_index)
  # return list1
  match row:
    case Result/Err:
      return List/Nil
    case Result/Ok:
      return get_row(row)

def index_into(list1, real_index, index_on):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      if real_index == index_on:
        return list1.head
      else:
        return index_into(list1.tail, real_index, index_on + 1)

def get_column(matrix, prev_outputs, col_index, real_matrix_index):
  match matrix:
    case List/Nil:
      return prev_outputs
    case List/Cons:
      correct_list = index_into(matrix, real_matrix_index, 0)
      # return correct_list
      match correct_list:
        case List/Nil:
          return prev_outputs
        case List/Cons:
          # return correct_list
          to_add = index(correct_list, col_index)
          match to_add:
            case Result/Err:
              return List/Nil
            case Result/Ok:
              new_to_add = index_into(correct_list, col_index, 0)
              new_outputs = concat(prev_outputs, [new_to_add])
              return get_column(matrix, new_outputs, col_index, real_matrix_index + 1)
          # return to_add


def transpose_matrix(A, col_index, transposed_matrix):
  column = get_column(A, [], col_index, 0)

  match column:
    case List/Nil:
      return transposed_matrix 
    case List/Cons:
      
      new_transposed_matrix = concat(transposed_matrix, [column])
      
      return transpose_matrix(A, col_index + 1, new_transposed_matrix)

def sum(A, total_sum):
  match A:
    case List/Nil:
      return total_sum
    case List/Cons:
      total_sum = total_sum + A.head
      return sum(A.tail, total_sum)

def dot_product(A, B):
  return sum(multiply_lists(A, B), 0)


def multiply_row_by_all_columns(row_A, B, col_index, result_list):
  column_B = get_column(B, [], col_index, 0)
  match column_B:
    case List/Nil:
      return result_list
    case List/Cons:
      # return column_B
      product = dot_product(row_A, column_B)
      new_list = concat(result_list, [product])
      # return new_list
      return multiply_row_by_all_columns(row_A, B, col_index+1, new_list)
  

def matrix_multiply(A, B, row_index, result_matrix):
  row_A = get_row_at_index(row_index, A)
  match row_A:
    case List/Nil:
      return result_matrix # this is when we are done with multiplying all the rows of A 
    case List/Cons:
      row_times_columns = multiply_row_by_all_columns(row_A, B, 0, [])
      new_matrix = concat(result_matrix, [row_times_columns])
      return matrix_multiply(A, B, row_index+1, new_matrix)


# Just in case I need to use this again 
def fake_e():
  return 2.71828

def sigmoid(list, applied_list):
  # iterate through the whole list/matrix and then apply sigmoid on all the elements 
  match list:
    case List/Nil:
      return applied_list
    case List/Cons:
      val = u24/to_i24(list.head)
      value = val * -1
      e_real_value = Math/E() ** u24/to_f24(list.head)
      denominator = u24/to_f24(1) + u24/to_f24(1)/e_real_value
      sig = u24/to_f24(1)/denominator
      updated_list = concat(applied_list, [sig])
      return sigmoid(list.tail, updated_list)

def sigmoid_to_whole_matrix(list, row_index, full_matrix):
  row_A = get_row_at_index(row_index, list)
  match row_A:
    case List/Nil:
      return full_matrix 
    case List/Cons:
      row_sum = sigmoid(row_A, [])
      new_matrix = concat(full_matrix, [row_sum]) 
      return sigmoid_to_whole_matrix(list, row_index + 1, new_matrix)

# sigmoid(W * x + b)
def forward_pass(input_matrix, weights_matrix, bias_vector):

  weighted_sum = matrix_multiply(input_matrix, weights_matrix, 0, [])
  # return weighted_sum

  # something strange here make sure that I understand the FULL forward pass completely
  weighted_sum_with_bias = add_matrix(weighted_sum, bias_vector, 0, [])
  # return weighted_sum_with_bias

  activated_output = sigmoid_to_whole_matrix(weighted_sum_with_bias, 0, [])

  return activated_output

def sum_square(A, total_square):
  match A:
    case List/Nil:
      return total_square
    case List/Cons:
      to_add = A.head * A.head
      # return to_add
      total_square = total_square + to_add
      return sum_square(A.tail, total_square)

def square_sum_and_mean(matrix, row_index, value):
  row_A = get_row_at_index(row_index, matrix)
  match row_A:
    case List/Nil:
      return value
    case List/Cons:
      # return row_A
      row_value = sum_square(row_A, 0)
      # return row_value
      value = value + row_value
      return square_sum_and_mean(matrix, row_index + 1, value)

def total_rows(matrix, row_index):
  row_A = get_row_at_index(row_index, matrix)
  # return row_A
  match row_A:
    case List/Nil:
      return row_index
    case List/Cons:
      return total_rows(matrix, row_index + 1)

def total_list_elements(list, list_index):
  # return row_A
  match list:
    case List/Nil:
      return list_index
    case List/Cons:
      return total_list_elements(list.tail, list_index + 1)

def mean_squared_error(predicted_values, true_values):
  
  true_minus_predicted = subtract_matrix(true_values, predicted_values, 0, [])

  square_mean_and_sum = square_sum_and_mean(true_minus_predicted, 0, 0)
  
  # num_rows = total_rows(true_minus_predicted, 0)

  return u24/to_f24(square_mean_and_sum)/u24/to_f24(2)

# this is where I define the learning rate 
def learning():
  return u24/to_f24(0.007)

def scalar_multiply(matrix, scalar, row_index, final_matrix):
  row_A = get_row_at_index(row_index, matrix)
  match row_A:
    case List/Nil:
      return final_matrix
    case List/Cons:
      # return row_A
      output_matrix = multiply_list_by_scalar(row_A, scalar)
      # return row_value
      new_matrix = concat(final_matrix, [output_matrix]) 
      return scalar_multiply(matrix, scalar, row_index + 1, new_matrix)

def scalar_list_subtraction(list1, scalar):
  match list1:
    case List/Nil:
      return List/Nil
    case List/Cons:
      h1 = list1.head
      t1 = list1.tail
      return List/Cons { head: u24/to_f24(scalar) - u24/to_f24(h1), tail: scalar_list_subtraction(t1, scalar) }

def scalar_matrix_subtraction(matrix, scalar, row_index, final_matrix):
  row_A = get_row_at_index(row_index, matrix)
  match row_A:
    case List/Nil:
      return final_matrix
    case List/Cons:
      # return row_A
      output_matrix = scalar_list_subtraction(row_A, scalar)
      # return row_value
      new_matrix = concat(final_matrix, [output_matrix]) 
      return scalar_matrix_subtraction(matrix, scalar, row_index + 1, new_matrix)

def sigmoid_derivative(A):
  # Derivative of the sigmoid function: sigmoid(z) * (1 - sigmoid(z))
  scalar_sub = scalar_matrix_subtraction(A, 1, 0, [])
  return matrix_multiply(scalar_sub, A, 0, [])


def backwards_pass(output_matrix, input_matrix, true_values, weights_matrix, bias_vector):

  # MAKE SURE TO COMPUTE THE DIMENSIONS AND MAKE SURE THE DIMENSIONS ACTUALLY WORK OUT!!!

  # calculate the derivative of the loss function
  loss_deriv = subtract_matrix(output_matrix, true_values, 0, [])

  sigmoid_deriv = sigmoid_derivative(output_matrix)
  
  # return sigmoid_deriv

  # loss_derivative * sigmoid derivative 
  delta_sigmoid = matrix_multiply(loss_deriv, sigmoid_deriv, 0, []) 

  # The gradient is delta^1 * A^0 (the input to the layer)
  gradient_W = matrix_multiply(delta_sigmoid, input_matrix, 0, [])

  # updated bias gradient (we just multiply by 1 here as the derivative is in respect to a constant)
  gradient_b = delta_sigmoid

  learning_rate = learning()

  updated_weights = subtract_matrix(weights_matrix, transpose_matrix(scalar_multiply(gradient_W, learning_rate, 0, []), 0, []), 0, [])
  updated_biases = subtract_matrix(bias_vector, scalar_multiply(gradient_b, learning_rate, 0, []), 0, [])


  return updated_weights, updated_biases


# I am going to use the Iris Dataset -> 80 training 20 testing around 10-20 epochs which should work to test this implementation

# setosa -> 0
# versicolor -> 1


def epochs(train_data, train_labels, bias_vector, weights_matrix, num_epochs):
  if num_epochs == 0:
    return weights_matrix, bias_vector
  else:
    weights_matrix, bias_vector = train(train_data, train_labels, bias_vector, weights_matrix, 0)
    return epochs(train_data, train_labels, bias_vector, weights_matrix, num_epochs - 1)

def train(train_data, train_labels, bias_vector, weights_matrix, row_index):
  input = get_row_at_index(row_index, train_data)
  match input:
    case List/Nil:
      return weights_matrix, bias_vector
    case List/Cons:
      match train_labels:
        case List/Nil:
          return weights_matrix, bias_vector
        case List/Cons:
          answer = train_labels.head
          # return answer
          output = forward_pass([input], weights_matrix, bias_vector)
          # return output
          weights_matrix, bias_vector = backwards_pass(output, [input], [[answer]], weights_matrix, bias_vector)
          return train(train_data, train_labels.tail, bias_vector, weights_matrix, row_index + 1)

def pick_label(input):
  if input >= 0.5:
    return 1
  else:
    return 0

def test(test_data, test_labels, bias_vector, weights_matrix, row_index, correct_predictions, total_predictions):
  input = get_row_at_index(row_index, test_data)
  match input:
    case List/Nil:
      # return correct_predictions
      accuracy = u24/to_f24(correct_predictions) / u24/to_f24(total_predictions)
      return accuracy
    case List/Cons:
      match test_labels:
        case List/Nil:
          accuracy = u24/to_f24(correct_predictions) / u24/to_f24(total_predictions)
          return accuracy
        case List/Cons:
          expected_label = test_labels.head
          output = forward_pass([input], weights_matrix, bias_vector)
          match output:
            case List/Nil:
              return List/Nil
            case List/Cons:
              fin_list = output.head
              predicted_label = index_into(fin_list, 0, 0)
              actual_prediction = pick_label(predicted_label)
              # return expected_label
              if actual_prediction == expected_label:
                correct_predictions = correct_predictions + 1
              else:
                correct_predictions = correct_predictions
              total_predictions = total_predictions + 1
              return test(test_data, test_labels.tail, bias_vector, weights_matrix, row_index + 1, correct_predictions, total_predictions)


def train_data():
  return [[5.5,2.4,3.8,1.1],
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

def test_data():
  return [[6.3,3.3,4.7,1.6],
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

def main() -> IO(List):


  initial_weights = [[0.71], 
          [0.23], 
          [0.04], 
          [0.21]]

  initial_bias = [[0.34]]


  training_data = train_data()

  training_labels = [1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 
1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1]


  testing_data = test_data()

  testing_labels = [1,1,1,0,0,0,1,1,1,0,0,1,1,0,1,0,0,0,1,0]

  weights, bias = epochs(training_data, training_labels, initial_bias, initial_weights, 500)

  return test(testing_data, testing_labels, bias, weights, 0, 0, 0)
