import csv
from collections import defaultdict
import re
import plotly.graph_objs as go
import dash
from dash import dcc, html, Input, Output
import plotly.express as px

filename = "C:/Users/Ian/Documents/eBird/MyEBirdData.csv"
filenameDownload = "C:/Users/Ian/Documents/eBird/MyEBirdDataExtractedAllColumns.csv"
filenameAggregatedSpecies = "C:/Users/Ian/Documents/eBird/MyEBirdDataSpeciesSum.csv"
target_value = "US-VT"
column_index = 5
target_value2 = "Chittenden"
column_index2 = 6


def IsolateCountyChecklists(filename, target_value, column_index, target_value_2, column_index_1):
    extracted_data = []
    header = None
    with open(filename, 'r', encoding='utf-8', errors='replace') as file:
        reader = csv.reader(file)
        header = next(reader)
        for row in reader:
            if (row[column_index].strip() == target_value and
                row[column_index_1].strip() == target_value_2):
                extracted_data.append(row)
    return header, extracted_data

header, CountyData = IsolateCountyChecklists(filename, target_value, column_index, target_value2, column_index2)

counter = 0  # Initialize the counter

for index, item in enumerate(CountyData):
    if item[2] != "None":  # Check if item[2] is not "None"
        # Ensure the list is long enough to add an index 23
        while len(item) <= 23:
            item.append(None)  # Fill with None or any placeholder
        
        item[23] = counter  # Set the counter at index 23
        CountyData[index] = item  # Update the list with the modified item
        counter += 1  # Increment the counter for the next item

"""
# Filtering logic
XCounts = [item for item in CountyData if len(item) > 4 and item[4] == 'X']
pattern = re.compile(r'\d')  # Compile the regex pattern for efficiency
result = [item for item in XCounts if len(item) > 20 and isinstance(item[20], str) and pattern.search(item[20])] #passes over sublists where item[20] is not a string
"""

# The following doesn't appear to capture all instances of 'x' and replace them with integers - for example, row ID 36 submission S150105153, Canada Geese
# Identifying CountyData records with count value of 'x'
result_dict = {}

for item in CountyData:
    if len(item) > 20 and item[4].upper() == 'X':
        # Extracting item[20]
        value_20 = str(item[20]) if item[20] is not None else ""

        # Extracting all integers from item[20]. Only preserving the smaller integer if two or more exist. May want to enhance this to extract the 'max' (ex. saw 1, heard about 10) value unless there are two integers around a hyphen (ex. ##-##) which in that case extract min
        integer_matches = re.findall(r'\d+', value_20)
        extracted_integer = min(int(num) for num in integer_matches) if integer_matches else None
        
        # Creating the dictionary entry
        result_dict[item[1]] = [item[4], value_20, extracted_integer, item[23]]

# Print each whole dictionary item
# Review outputs for quality control
for key, value in result_dict.items():
    print(f"Key: {key}, Value: {value}")

# Dictionary of all 'x' count values with a replaceable integer found in the sighting comments 
ReplaceableXCounts_dict = {}

for key, item in result_dict.items():
    if item[2] is not None and item[2] != "None":
        ReplaceableXCounts_dict[key] = item

# iterate through CountyData to find when identifying key matches identifying key of ReplaceableXCounts_dict
for item in CountyData:
    for key, values in ReplaceableXCounts_dict.items():
        if values[3] == item[23]: #check if dictionary values[3] matches CountyData sublist[23]
            item[4] = values[2] #when there is a match, replace CountyData sublist[4] with dictionary values[2], which is the extracted integer to replace 'x' value counts

def sum_by_species(header, CountyData, columns_to_keep, group_column_index, sum_column_index):
    sum_species_header = [header[i] for i in columns_to_keep]
    
    species_sum = defaultdict(int)  # Initialize with int to sum values

    for row in CountyData:
        group_value = row[group_column_index]
        
        # Attempt to convert to float
        try:
            sum_value = float(row[sum_column_index])  # Convert to float for summation
            species_sum[group_value] += sum_value  # Accumulate the count
        except ValueError:
            continue  # Skip row with values which result in error (x values instead of number)

    return sum_species_header, species_sum

sum_species_header, species_totalCount = sum_by_species(header, CountyData, [1, 2, 3, 4, 5, 6], 1, 4)

# Step 1: Count unique values in Column 0
unique_col0 = set(row[0] for row in CountyData)
unique_count_col0 = len(unique_col0)

# Step 2: Count how many unique values of Column 0 each unique value of Column 1 is found in
col1_to_col0 = {}

for row in CountyData:
    col0_value = row[0]
    col1_value = row[1]
    
    if col1_value not in col1_to_col0:
        col1_to_col0[col1_value] = set()
    
    col1_to_col0[col1_value].add(col0_value)

# Step 3: Calculate the percentage
percentage_col1 = {}
for col1_value, col0_values in col1_to_col0.items():
    unique_count_col1 = len(col0_values)
    percentage_col1[col1_value] = (unique_count_col1 / unique_count_col0) * 100

# Create a new dictionary to store the combined results
combined_dict = {}

for key in percentage_col1.keys():
    if key in species_totalCount:
        combined_dict[key] = (percentage_col1[key], species_totalCount[key])


""" ### Functioning Plotly scatterplot


# Extracting data using a for loop
x_values = []
y_values = []

for key, value in combined_dict.items():
    x_values.append(value[1])  # First element for x
    y_values.append(value[0])  # Second element for y

# Create scatter plot without text labels
max_marker_size = 15  # Set your desired maximum marker size

fig = go.Figure(data=go.Scatter(
    x=x_values,
    y=y_values,
    mode='markers',
    marker=dict(
        size=x_values,
        sizeref=max(x_values) / (max_marker_size ** 2),
        minsize = 10
    )  
))

# Update layout
fig.update_layout(
    title='Bird Species Scatter Plot',
    xaxis_title='Count of Individual Birds',
    yaxis_title='% Checklists Species Observed'
)

# Show the plot
fig.show()
"""

# Extract x and y values along with keys for popups
x_values = []
y_values = []
hover_texts = []

for key, value in combined_dict.items():
    x_values.append(value[1])  # First element for x
    y_values.append(value[0])  # Second element for y
    hover_texts.append(f"{key}<br>Identified in {value[0]:.2f}% of Checklists<br>Counted {value[1]:.0f} Individuals")  # Custom popup text

# Initialize Dash app
app = dash.Dash(__name__, suppress_callback_exceptions=True)

# Specify custom marks for the slider
slider_marks = {i: str(i) for i in range(0, int(max(x_values)), 100)}

app.layout = html.Div([
    dcc.Graph(id='scatter-plot'),
    dcc.RangeSlider(
        id='x-range-slider',
        min=min(x_values),
        max=max(x_values),
        value=[min(x_values), max(x_values)],
        marks=slider_marks,
        step=50
    )
])

@app.callback(
    Output('scatter-plot', 'figure'),
    Input('x-range-slider', 'value')
)
def update_scatter_plot(x_range):
    # Filter x and y values based on the selected range
    filtered_x = [x for x in x_values if x_range[0] <= x <= x_range[1]]
    filtered_y = [y_values[i] for i, x in enumerate(x_values) if x_range[0] <= x <= x_range[1]]
    filtered_hover_texts = [hover_texts[i] for i, x in enumerate(x_values) if x_range[0] <= x <= x_range[1]]

    # Calculate the maximum y value, defaulting to 0 if no values are filtered
    max_y = max(filtered_y) if filtered_y else 0
    # Determine max value on y-axis
    if max_y > 0:
        max_y_rounded = ((max_y // 10) + 1.5) * 10
    else:
        max_y_rounded = 10  # Default to 10 if max_y is 0

    max_x= max(filtered_x) if filtered_x else 0
    if max_x > 0:
        max_x_rounded = ((max_x // 10) + 15) * 10
    else:
        max_x_rounded = 10  # Default to 10 if max_y is 0

    max_marker_size = 15
    fig = go.Figure(data=go.Scatter(
        x=filtered_x,
        y=filtered_y,
        mode='markers',
        marker=dict(
            size=filtered_x,
            sizeref=max(filtered_x) / (max_marker_size ** 2),
        ),
        text=filtered_hover_texts,  # Custom hover text
        hoverinfo='text'  # Show only the text on hover
    ))

    fig.update_layout(
        title='Bird Species Count and Frequency',
        xaxis_title='Count of Individual Birds',
        yaxis_title='% Checklists Species Observed',
        yaxis=dict(range=[0, max_y_rounded]),  # Set y-axis range from 0 to rounded max y
        xaxis=dict(range=[0, max_x_rounded])
    )

    return fig

if __name__ == '__main__':
    app.run_server(debug=True, port=8055)



with open(filenameDownload, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header)
    writer.writerows(CountyData)

with open(filenameAggregatedSpecies, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Species', 'PercOfChecklists', 'Count'])  # Write header
    for key, value in combined_dict.items():
        # Assuming value is a list with [PercOfChecklists, Count]
        writer.writerow([key, value[0], value[1]])  # Unpack the list
