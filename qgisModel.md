## First QGIS Model
In this week's lab, I created a model to calculate distance and direction of a city's census tracts from a single point. 

<!DOCTYPE model>
<Option type="Map">
  <Option type="Map" name="children">
    <Option type="Map" name="native:centroids_1">
      <Option type="bool" name="active" value="true"/>
      <Option name="alg_config"/>
      <Option type="QString" name="alg_id" value="native:centroids"/>
      <Option type="QString" name="component_description" value="Centroids"/>
      <Option type="double" name="component_pos_x" value="349.5728155339806"/>
      <Option type="double" name="component_pos_y" value="108.45631067961165"/>
      <Option name="dependencies"/>
      <Option type="QString" name="id" value="native:centroids_1"/>
      <Option name="outputs"/>
      <Option type="bool" name="outputs_collapsed" value="true"/>
      <Option type="bool" name="parameters_collapsed" value="true"/>
      <Option type="Map" name="params">
        <Option type="List" name="ALL_PARTS">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="bool" name="static_value" value="false"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option type="QString" name="parameter_name" value="citycenter"/>
            <Option type="int" name="source" value="0"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="native:meancoordinates_1">
      <Option type="bool" name="active" value="true"/>
      <Option name="alg_config"/>
      <Option type="QString" name="alg_id" value="native:meancoordinates"/>
      <Option type="QString" name="component_description" value="Mean coordinate(s)"/>
      <Option type="double" name="component_pos_x" value="563.135922330097"/>
      <Option type="double" name="component_pos_y" value="183.98058252427177"/>
      <Option name="dependencies"/>
      <Option type="QString" name="id" value="native:meancoordinates_1"/>
      <Option name="outputs"/>
      <Option type="bool" name="outputs_collapsed" value="true"/>
      <Option type="bool" name="parameters_collapsed" value="true"/>
      <Option type="Map" name="params">
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option type="QString" name="child_id" value="native:centroids_1"/>
            <Option type="QString" name="output_name" value="OUTPUT"/>
            <Option type="int" name="source" value="1"/>
          </Option>
        </Option>
        <Option type="List" name="UID">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="invalid" name="static_value"/>
          </Option>
        </Option>
        <Option type="List" name="WEIGHT">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="invalid" name="static_value"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_1">
      <Option type="bool" name="active" value="true"/>
      <Option name="alg_config"/>
      <Option type="QString" name="alg_id" value="qgis:fieldcalculator"/>
      <Option type="QString" name="component_description" value="Field calculator (distance)"/>
      <Option type="double" name="component_pos_x" value="360.53398058252424"/>
      <Option type="double" name="component_pos_y" value="288.8543689320388"/>
      <Option type="StringList" name="dependencies">
        <Option type="QString" value="native:meancoordinates_1"/>
      </Option>
      <Option type="QString" name="id" value="qgis:fieldcalculator_1"/>
      <Option name="outputs"/>
      <Option type="bool" name="outputs_collapsed" value="true"/>
      <Option type="bool" name="parameters_collapsed" value="true"/>
      <Option type="Map" name="params">
        <Option type="List" name="FIELD_LENGTH">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="10"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_NAME">
          <Option type="Map">
            <Option type="QString" name="expression" value=" concat ( @fieldnameprefix , 'Dist')"/>
            <Option type="int" name="source" value="3"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_PRECISION">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="14"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_TYPE">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="0"/>
          </Option>
        </Option>
        <Option type="List" name="FORMULA">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="QString" name="static_value" value="distance(centroid($geometry), &#xd;&#xa; make_point(  @Mean_coordinate_s__OUTPUT_maxx  ,  @Mean_coordinate_s__OUTPUT_maxy ))"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option type="QString" name="parameter_name" value="inputfeautres"/>
            <Option type="int" name="source" value="0"/>
          </Option>
        </Option>
        <Option type="List" name="NEW_FIELD">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="bool" name="static_value" value="false"/>
          </Option>
        </Option>
      </Option>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_2">
      <Option type="bool" name="active" value="true"/>
      <Option name="alg_config"/>
      <Option type="QString" name="alg_id" value="qgis:fieldcalculator"/>
      <Option type="QString" name="component_description" value="Field calculator (direction)"/>
      <Option type="double" name="component_pos_x" value="353.53398058252424"/>
      <Option type="double" name="component_pos_y" value="474.8543689320388"/>
      <Option name="dependencies"/>
      <Option type="QString" name="id" value="qgis:fieldcalculator_2"/>
      <Option type="Map" name="outputs">
        <Option type="Map" name="Direction Distance Output">
          <Option type="QString" name="child_id" value="qgis:fieldcalculator_2"/>
          <Option type="QString" name="component_description" value="Direction Distance Output"/>
          <Option type="double" name="component_pos_x" value="553.5339805825242"/>
          <Option type="double" name="component_pos_y" value="519.8543689320388"/>
          <Option type="invalid" name="default_value"/>
          <Option type="bool" name="mandatory" value="false"/>
          <Option type="QString" name="name" value="Direction Distance Output"/>
          <Option type="QString" name="output_name" value="OUTPUT"/>
        </Option>
      </Option>
      <Option type="bool" name="outputs_collapsed" value="true"/>
      <Option type="bool" name="parameters_collapsed" value="true"/>
      <Option type="Map" name="params">
        <Option type="List" name="FIELD_LENGTH">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="10"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_NAME">
          <Option type="Map">
            <Option type="QString" name="expression" value=" concat(  @fieldnameprefix , 'DIR')&#xd;&#xa; "/>
            <Option type="int" name="source" value="3"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_PRECISION">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="3"/>
          </Option>
        </Option>
        <Option type="List" name="FIELD_TYPE">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="int" name="static_value" value="0"/>
          </Option>
        </Option>
        <Option type="List" name="FORMULA">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="QString" name="static_value" value="degrees(azimuth( make_point(  @Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy ), centroid($geometry)))"/>
          </Option>
        </Option>
        <Option type="List" name="INPUT">
          <Option type="Map">
            <Option type="QString" name="child_id" value="qgis:fieldcalculator_1"/>
            <Option type="QString" name="output_name" value="OUTPUT"/>
            <Option type="int" name="source" value="1"/>
          </Option>
        </Option>
        <Option type="List" name="NEW_FIELD">
          <Option type="Map">
            <Option type="int" name="source" value="2"/>
            <Option type="bool" name="static_value" value="true"/>
          </Option>
        </Option>
      </Option>
    </Option>
  </Option>
  <Option type="Map" name="help">
    <Option type="QString" name="" value=""/>
    <Option type="QString" name="ALG_CREATOR" value=""/>
    <Option type="QString" name="ALG_DESC" value="A model to calculate the distance and degrees of census tracts from a single point. In this example, I used the center business district of Chicago as my central point to calculate the distance and degree orientation of the city's census tracts from the business district. "/>
    <Option type="QString" name="ALG_HELP_CREATOR" value=""/>
    <Option type="QString" name="ALG_VERSION" value=""/>
    <Option type="QString" name="SHORT_DESCRIPTION" value=""/>
    <Option type="QString" name="citycenter" value="A vector feature slot to input a 'CBD' spatial layer, short for Center Business District. This spatial layer can have data which is either a single point on a map or a series of polygons which represent the business district of the city.&#xa;&#xa;The centroid algorithm function has an input of the CBD spatial layer and an output which determines the center point of each polygon that is a part of the original CBD spatial layer. If the original CBD spatial layer is already a point, no harm is created when this function runs. &#xa;&#xa;The mean coordinate(s) algorithm function then takes the center point of each polygon and finds the average of these points. In effect, this determines a single point, bounded by both maximum and minumum x-y coordinates, to refer to as the CBD for all measurements. "/>
    <Option type="QString" name="fieldnameprefix" value="This input adds 'CBD' as a prefix onto the chosen result field name in the field calculators. "/>
    <Option type="QString" name="inputfeautres" value="A vector feature slot to input a city's spatial layer in which the census tracts of the city are independent polygons."/>
    <Option type="QString" name="qgis:fieldcalculator_2:Direction Distance Output" value="This output contains the distance of the central point of each census tract from the center business district in meters and the degree of orientation of those tracts from the CBD.&#xa;&#xa;Of course, this model can be used to calculate distance and direction from any point in a city if you so choose and not just the center business district. &#xa;"/>
  </Option>
  <Option type="QString" name="model_group" value=""/>
  <Option type="QString" name="model_name" value="Distance and Direction from Point"/>
  <Option type="Map" name="parameterDefinitions">
    <Option type="Map" name="citycenter">
      <Option type="List" name="data_types">
        <Option type="int" value="-1"/>
      </Option>
      <Option type="invalid" name="default"/>
      <Option type="QString" name="description" value="City Center"/>
      <Option type="int" name="flags" value="0"/>
      <Option name="metadata"/>
      <Option type="QString" name="name" value="citycenter"/>
      <Option type="QString" name="parameter_type" value="source"/>
    </Option>
    <Option type="Map" name="fieldnameprefix">
      <Option type="QString" name="default" value="CBD"/>
      <Option type="QString" name="description" value="Field Name Prefix"/>
      <Option type="int" name="flags" value="0"/>
      <Option name="metadata"/>
      <Option type="bool" name="multiline" value="false"/>
      <Option type="QString" name="name" value="fieldnameprefix"/>
      <Option type="QString" name="parameter_type" value="string"/>
    </Option>
    <Option type="Map" name="inputfeautres">
      <Option type="List" name="data_types">
        <Option type="int" value="2"/>
      </Option>
      <Option type="invalid" name="default"/>
      <Option type="QString" name="description" value="Input Feautres"/>
      <Option type="int" name="flags" value="0"/>
      <Option name="metadata"/>
      <Option type="QString" name="name" value="inputfeautres"/>
      <Option type="QString" name="parameter_type" value="vector"/>
    </Option>
    <Option type="Map" name="qgis:fieldcalculator_2:Direction Distance Output">
      <Option type="bool" name="create_by_default" value="true"/>
      <Option type="int" name="data_type" value="-1"/>
      <Option type="invalid" name="default"/>
      <Option type="QString" name="description" value="Direction Distance Output"/>
      <Option type="int" name="flags" value="0"/>
      <Option name="metadata"/>
      <Option type="QString" name="name" value="qgis:fieldcalculator_2:Direction Distance Output"/>
      <Option type="QString" name="parameter_type" value="sink"/>
      <Option type="bool" name="supports_non_file_outputs" value="true"/>
    </Option>
  </Option>
  <Option type="Map" name="parameters">
    <Option type="Map" name="citycenter">
      <Option type="QString" name="component_description" value="citycenter"/>
      <Option type="double" name="component_pos_x" value="116.47572815533977"/>
      <Option type="double" name="component_pos_y" value="54.514563106796146"/>
      <Option type="QString" name="name" value="citycenter"/>
    </Option>
    <Option type="Map" name="fieldnameprefix">
      <Option type="QString" name="component_description" value="fieldnameprefix"/>
      <Option type="double" name="component_pos_x" value="124.42718446601953"/>
      <Option type="double" name="component_pos_y" value="370.8446601941747"/>
      <Option type="QString" name="name" value="fieldnameprefix"/>
    </Option>
    <Option type="Map" name="inputfeautres">
      <Option type="QString" name="component_description" value="inputfeautres"/>
      <Option type="double" name="component_pos_x" value="119.72815533980588"/>
      <Option type="double" name="component_pos_y" value="193.18446601941747"/>
      <Option type="QString" name="name" value="inputfeautres"/>
    </Option>
  </Option>
</Option>('create-download-link')

[Return to Main Page](index.md)
