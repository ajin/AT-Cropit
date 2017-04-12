set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.4.00.12'
,p_default_workspace_id=>1691214649525975
,p_default_application_id=>109
,p_default_owner=>'PLAYGROUND'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/net_tuladhar_item_at_cropit
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(58965461584995705)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'NET.TULADHAR.ITEM.AT-CROPIT'
,p_display_name=>'AT Cropit'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#jquery.cropit.js',
'#PLUGIN_FILES#at-cropit.js'))
,p_css_file_urls=>'#PLUGIN_FILES#at-cropit.css'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/**',
' * Render the placeholder of the plugin during the page load',
' *',
' * @param p_item',
' * @param p_plugin',
' * @param p_value',
' * @param p_is_readonly',
' * @param p_is_printer_friendly',
' * @return t_page_item_render_result result type for the rendering function of a region type plug-in',
' */',
'function render (',
'    p_item                in apex_plugin.t_page_item,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_value               in varchar2,',
'    p_is_readonly         in boolean,',
'    p_is_printer_friendly in boolean',
') return apex_plugin.t_page_item_render_result is',
'',
'  c_plugin_namespace  varchar2(200)    := ''at_cropit'';',
'  l_output_html			  varchar2(32767)  := null;',
'  l_output_js         varchar2(32767)  := null;',
'  l_result            apex_plugin.t_page_item_render_result;',
'',
'  c_item_uid          number           := p_item.id; --uid',
'  c_item_name         varchar2(255)    := p_item.name; --P1_NAME',
'',
'  c_item_page_id      varchar2(30)     := apex_plugin.get_input_name_for_page_item(p_is_multi_value => false); -- p_t01',
'  c_ajax_identifier		varchar2(254)    := apex_plugin.get_ajax_identifier;',
'',
'  -- constant values',
'  c_item_class		varchar2(254)  := ''image-editor '';',
'  c_item_div      varchar2(254)  := ''<div class="#CLASS#" id="at_cropit_#ID#">',
'        <input type="file" class="cropit-image-input" id="#ID#" name="#NAME#">',
'        <div class="cropit-preview"></div>',
'      </div>'';',
'',
'  -- attributes defined section option',
'  l_attr_width      varchar2(40)  := p_item.attribute_01;',
'  l_attr_height     varchar2(40)  := p_item.attribute_02;',
'  l_attr_image_background varchar2(1)  := p_item.attribute_03;',
'  l_attr_image_bg_br_width varchar2(40)  := p_item.attribute_04;',
'  l_attr_export_zoom      varchar2(40)  := p_item.attribute_05;',
'  l_attr_allow_dragndrop  varchar2(1)   := p_item.attribute_06;',
'  l_attr_min_zoom         varchar2(40)  := p_item.attribute_07;',
'  l_attr_max_zoom         varchar2(40)  := p_item.attribute_08;',
'  l_attr_initial_zoom     varchar2(40)  := p_item.attribute_09;',
'  l_attr_free_move        varchar2(1)   := p_item.attribute_10;',
'  l_attr_small_image      varchar2(255) := p_item.attribute_11;',
'',
'  l_attr_image_type       varchar2(255) := nvl(p_item.attribute_12, ''image/png'');',
'  l_attr_image_quality    varchar2(40)  := nvl(p_item.attribute_13, ''0.75'');',
'  l_attr_original_size    varchar2(1)   := p_item.attribute_14;',
'',
'begin',
'  apex_debug.message( c_plugin_namespace || '' @ begin'' );',
'  apex_debug.message( c_plugin_namespace || '' @ building html code'' );',
'',
'  l_output_html := replace(c_item_div, ''#ID#'', c_item_name);',
'  l_output_html := replace(l_output_html, ''#NAME#'', c_item_page_id);',
'  l_output_html := replace(l_output_html, ''#CLASS#'', c_item_class || p_item.element_css_classes) ;',
'',
'  apex_debug.message( c_plugin_namespace || '' @ l_output_html: '' || l_output_html );',
'  sys.htp.p(l_output_html);',
'',
'  l_output_js := ''atcropit("at_cropit_'' || c_item_name || ''", {'';',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''ajax_identifier'', c_ajax_identifier);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''type'', l_attr_image_type);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''quality'', l_attr_image_quality);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''originalSize'', case when l_attr_original_size = ''Y'' then true else false end);',
'',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''defaultImageSrc'', p_value);',
'',
'  if l_attr_width is not null then',
'    l_output_js := l_output_js || apex_javascript.add_attribute(''width'', l_attr_width);',
'  end if;',
'',
'  if l_attr_height is not null then',
'    l_output_js := l_output_js || apex_javascript.add_attribute(''height'', l_attr_height);',
'  end if;',
'',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''imageBackground'', case when l_attr_image_background = ''Y'' then true else false end );',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''imageBackgroundBorderWidth'', l_attr_image_bg_br_width);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''exportZoom'', l_attr_export_zoom);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''allowDragNDrop'', case when l_attr_allow_dragndrop = ''Y'' then true else false end );',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''minZoom'', l_attr_min_zoom);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''maxZoom'', l_attr_max_zoom);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''initialZoom'', l_attr_initial_zoom);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''freeMove'',  case when l_attr_free_move = ''Y'' then true else false end);',
'  l_output_js := l_output_js || apex_javascript.add_attribute(''smallImage'', l_attr_small_image);',
'',
'  l_output_js := l_output_js || ''});'';',
'',
'  apex_javascript.add_onload_code( p_code => l_output_js);',
'',
'  apex_debug.message( c_plugin_namespace || '' @ end'' );',
'  return null;',
'end;',
'',
'function ajax_render (',
'    p_item   in apex_plugin.t_page_item,',
'    p_plugin in apex_plugin.t_plugin )',
'return apex_plugin.t_page_item_ajax_result is',
'',
'  c_plugin_namespace  varchar2(200)    := ''at_cropit @ ajax_render'';',
'  c_item_uid          number           := p_item.id; --uid',
'  c_item_name         varchar2(255)    := p_item.name; --P1_NAME',
'',
'  l_clob              clob;',
'  l_blob              blob;',
'  l_part              varchar2(32000);',
'',
'  l_filename          varchar2(200);',
'  l_mime_type         varchar2(200);',
'',
'begin',
'',
'  apex_debug.message( c_plugin_namespace || '' @ begin'' );',
'  apex_debug.message( c_plugin_namespace || '' @ collection_name '' || c_item_name);',
'  apex_debug.message( c_plugin_namespace || '' @ g_x01 '' || apex_application.g_x01);',
'  apex_debug.message( c_plugin_namespace || '' @ g_x02 '' || apex_application.g_x02);',
'',
'  l_filename  := apex_application.g_x01;',
'  l_mime_type := apex_application.g_x02;',
'',
'  -- use only for uploading files/image',
'  dbms_lob.createtemporary(l_clob, false, dbms_lob.session);',
'  apex_debug.message( c_plugin_namespace || '' @ g_f01.count '' || apex_application.g_f01.count);',
'',
'  for i in 1..apex_application.g_f01.count loop',
'    l_part := apex_application.g_f01(i);',
'    if length(l_part) > 0 then',
'      dbms_lob.writeappend(l_clob, length(l_part), l_part);',
'    end if;',
'  end loop;',
'',
'  -- convert base64 CLOB to BLOB',
'  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);',
'  apex_debug.message( c_plugin_namespace || '' @ blob length '' || dbms_lob.getlength(l_blob));',
'',
'  -- register collection with item name',
'  apex_collection.create_or_truncate_collection(p_collection_name => c_item_name);',
'',
'  -- add collection member (only if BLOB is not null)',
'  if dbms_lob.getlength(l_blob) is not null then',
'    apex_collection.add_member(',
'      p_collection_name => c_item_name,',
'      p_c001 => l_filename,',
'      p_c002 => l_mime_type,',
'      p_blob001 => l_blob',
'    );',
'  end if;',
'',
'  -- build return JSON value',
'  apex_json.open_object;',
'  apex_json.write(''result'', ''success'');',
'  apex_json.close_object;',
'  return null;',
'',
'  apex_debug.message( c_plugin_namespace || '' @ end'' );',
'',
'end;',
''))
,p_render_function=>'render'
,p_ajax_function=>'ajax_render'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:SOURCE:ENCRYPT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.5.1.170411'
,p_about_url=>'http://www.tuladhar.net'
,p_files_version=>57
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29634526412208839)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Width'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_unit=>'px'
,p_is_translatable=>false
,p_help_text=>'Width of image preview in pixels. If set, it will override the CSS property.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29635111441210686)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Heght'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_unit=>'px'
,p_is_translatable=>false
,p_help_text=>'Height of image preview in pixels. If set, it will override the CSS property.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29635747531213100)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Image Background'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Whether or not to display the background image beyond the preview area.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29636309119222906)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Image Background Border Width'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'[0,0,0,0]'
,p_is_translatable=>false
,p_examples=>'[0,0,0,0]'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Width of background image border in pixels. The four array elements specify the width of background image width on the top, right, bottom, left side respectively. The background image beyond the width will be hidden. If specified as a number, border '
||'with uniform width on all sides will be applied.',
'<br/>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29636962211228745)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Export Zoom'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_help_text=>'The ratio between the desired image size to export and the preview size. For example, if the preview size is 300px * 200px, and exportZoom = 2, then the exported image size will be 600px * 400px. This also affects the maximum zoom level, since the ex'
||'ported image cannot be zoomed to larger than its original size.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29637531034231998)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Alllow Drag and Drop'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'When set to true, you can load an image by dragging it from local file browser onto the preview area.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29638163563235582)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Min Zoom'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'fill'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This options decides the minimal zoom level of the image.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29638773253237823)
,p_plugin_attribute_id=>wwv_flow_api.id(29638163563235582)
,p_display_sequence=>10
,p_display_value=>'Fill'
,p_return_value=>'fill'
,p_help_text=>'If set to ''fill'', the image has to fill the preview area, i.e. both width and height must not go smaller than the preview area.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29639164147238378)
,p_plugin_attribute_id=>wwv_flow_api.id(29638163563235582)
,p_display_sequence=>20
,p_display_value=>'Fit'
,p_return_value=>'fit'
,p_help_text=>'If set to ''fit'', the image can shrink further to fit the preview area, i.e. at least one of its edges must not go smaller than the preview area.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29640027311248217)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Max Zoom'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_help_text=>'Determines how big the image can be zoomed. E.g. if set to 1.5, the image can be zoomed to 150% of its original size.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29640655132250387)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Initial Zoom'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'min'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Determines the zoom when an image is loaded.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29641270121251841)
,p_plugin_attribute_id=>wwv_flow_api.id(29640655132250387)
,p_display_sequence=>10
,p_display_value=>'Min'
,p_return_value=>'min'
,p_help_text=>'When set to ''min'', image is zoomed to the smallest when loaded.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29641613730252560)
,p_plugin_attribute_id=>wwv_flow_api.id(29640655132250387)
,p_display_sequence=>20
,p_display_value=>'Image'
,p_return_value=>'image'
,p_help_text=>'When set to ''image'', image is zoomed to 100% when loaded.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29642514805257440)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Free Move'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'When set to true, you can freely move the image instead of being bound to the container borders'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29643176181261329)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Small Image'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'reject'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29643730077262511)
,p_plugin_attribute_id=>wwv_flow_api.id(29643176181261329)
,p_display_sequence=>10
,p_display_value=>'Reject'
,p_return_value=>'reject'
,p_help_text=>'When set to ''reject'', onImageError would be called when cropit loads an image that is smaller than the container.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29644137727263500)
,p_plugin_attribute_id=>wwv_flow_api.id(29643176181261329)
,p_display_sequence=>20
,p_display_value=>'Allow'
,p_return_value=>'allow'
,p_help_text=>'When set to ''allow'', images smaller than the container can be zoomed down to its original size, overiding minZoom option.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29644518630264249)
,p_plugin_attribute_id=>wwv_flow_api.id(29643176181261329)
,p_display_sequence=>30
,p_display_value=>'Stretch'
,p_return_value=>'stretch'
,p_help_text=>'When set to ''stretch'', the minimum zoom of small images would follow minZoom option.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29650556936421826)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>3
,p_prompt=>'Exported Image Type'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'image/png'
,p_is_translatable=>false
,p_help_text=>'exported image type'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29651114151427587)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>4
,p_prompt=>'Exported Image Quality'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'0.75'
,p_is_translatable=>false
,p_help_text=>'exported image quality, only works when type is ''image/jpeg'' or ''image/webp'''
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29651734191431379)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Original Size'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'When set to true, export cropped part in original size, overriding exportZoom.'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29584707398062581)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onfilechange'
,p_display_name=>'onFileChange'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29585096614062582)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onfilereadererror'
,p_display_name=>'onFileReaderError'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29586263952062582)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onimageerror'
,p_display_name=>'onImageError'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29585822510062582)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onimageloaded'
,p_display_name=>'onImageLoaded'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29585496810062582)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onimageloading'
,p_display_name=>'onImageLoading'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29587818654062585)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onoffsetchange'
,p_display_name=>'onOffsetChange'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29587492438062584)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onzoomchange'
,p_display_name=>'onZoomChange'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29587081146062584)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onzoomdisabled'
,p_display_name=>'onZoomDisabled'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(29586635775062584)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_name=>'at-cropit-onzoomenabled'
,p_display_name=>'onZoomEnabled'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '282066756E6374696F6E2820242C207574696C2029207B0A0A2F2A2A0A202A2040706172616D207B537472696E677D2070526567696F6E49640A202A2040706172616D207B4F626A6563747D205B704F7074696F6E735D0A202A2A2F0A617463726F7069';
wwv_flow_api.g_varchar2_table(2) := '74203D2066756E6374696F6E28206974656D49642C206F7074696F6E732029207B0A2020766172206974656D203D20272327202B207574696C2E65736361706543535328206974656D496420293B0A0A20207661722064656661756C7473203D207B0A20';
wwv_flow_api.g_varchar2_table(3) := '202020736F757263655F74797065203A2027434F4C4C454354494F4E272C0A0A202020206F6E46696C654368616E67653A2066756E6374696F6E286F626A65637429207B0A202020202020617065782E6576656E742E74726967676572286974656D2C20';
wwv_flow_api.g_varchar2_table(4) := '2261742D63726F7069742D6F6E66696C656368616E6765222C207B6F626A6563747D293B0A202020207D2C0A202020206F6E46696C655265616465724572726F723A2066756E6374696F6E2829207B0A202020202020617065782E6576656E742E747269';
wwv_flow_api.g_varchar2_table(5) := '67676572286974656D2C202261742D63726F7069742D6F6E66696C657265616465726572726F72222C207B7D293B0A202020207D2C0A202020206F6E496D6167654C6F6164696E673A2066756E6374696F6E2829207B0A202020202020617065782E6576';
wwv_flow_api.g_varchar2_table(6) := '656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E696D6167656C6F6164696E67222C207B7D293B0A202020207D2C0A202020206F6E496D6167654C6F616465643A2066756E6374696F6E2829207B0A20202020202061706578';
wwv_flow_api.g_varchar2_table(7) := '2E6576656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E696D6167656C6F61646564222C207B7D293B0A202020207D2C0A202020206F6E496D6167654572726F723A2066756E6374696F6E286F626A6563742C206E756D6265';
wwv_flow_api.g_varchar2_table(8) := '722C20737472696E6729207B0A202020202020617065782E6576656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E696D6167656572726F72222C207B6F626A6563742C206E756D6265722C20737472696E677D293B0A202020';
wwv_flow_api.g_varchar2_table(9) := '207D2C0A202020206F6E5A6F6F6D456E61626C65643A2066756E6374696F6E2829207B0A202020202020617065782E6576656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E7A6F6F6D656E61626C6564222C207B7D293B0A20';
wwv_flow_api.g_varchar2_table(10) := '2020207D2C0A202020206F6E5A6F6F6D44697361626C65643A2066756E6374696F6E2829207B0A202020202020617065782E6576656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E7A6F6F6D64697361626C6564222C207B7D';
wwv_flow_api.g_varchar2_table(11) := '293B0A202020207D2C0A202020206F6E5A6F6F6D4368616E67653A2066756E6374696F6E286E756D62657229207B0A202020202020617065782E6576656E742E74726967676572286974656D2C202261742D63726F7069742D6F6E7A6F6F6D6368616E67';
wwv_flow_api.g_varchar2_table(12) := '65222C207B6E756D6265727D293B0A202020207D2C0A202020206F6E4F66667365744368616E67653A2066756E6374696F6E286F626A65637429207B0A202020202020617065782E6576656E742E74726967676572286974656D2C202261742D63726F70';
wwv_flow_api.g_varchar2_table(13) := '69742D6F6E6F66667365746368616E6765222C207B6F626A6563747D293B0A202020207D0A20207D0A2020766172206F7074696F6E73203D20242E657874656E642864656661756C74732C206F7074696F6E73293B0A0A202024286974656D292E63726F';
wwv_flow_api.g_varchar2_table(14) := '706974286F7074696F6E73293B0A202024286974656D292E63726F7069742827696D616765537263272C206F7074696F6E732E64656661756C74496D616765537263293B0A0A2020242822666F726D22292E7375626D69742866756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(15) := '7B0A20202020652E70726576656E7444656661756C7428293B0A0A202020202F2F20696620757365722073656C6563747320636F6C6C656374696F6E20617320736F757263652C2069742077696C6C2066697273742075706C6F61640A202020202F2F20';
wwv_flow_api.g_varchar2_table(16) := '746F206170706C69636174696F6E5F636F6C6C656374696E6F0A20202020696620286F7074696F6E732E736F757263655F74797065203D3D2027434F4C4C454354494F4E27297B0A2020202020207661722063757272656E74546172676574203D20652E';
wwv_flow_api.g_varchar2_table(17) := '7461726765743B0A2020202020206F6E5375626D69742866756E6374696F6E28297B0A202020202020202063757272656E745461726765742E7375626D697428293B0A2020202020207D293B0A202020207D0A20207D293B0A0A202066756E6374696F6E';
wwv_flow_api.g_varchar2_table(18) := '206F6E5375626D69742863616C6C6261636B297B0A2020202076617220696D61676544617461203D2024286974656D292E63726F70697428276578706F7274272C207B0A2020202020202020747970653A206F7074696F6E732E747970652C0A20202020';
wwv_flow_api.g_varchar2_table(19) := '202020207175616C6974793A206F7074696F6E732E7175616C6974792C0A20202020202020206F726967696E616C53697A653A206F7074696F6E732E6F726967696E616C53697A650A202020207D293B0A0A202020207661722066696C65496E70757420';
wwv_flow_api.g_varchar2_table(20) := '3D2024286974656D292E66696E642827696E7075742E63726F7069742D696D6167652D696E70757427293B0A20202020766172206E616D65203D2066696C65496E7075745B305D2E66696C65732E6C656E677468203F2066696C65496E7075745B305D2E';
wwv_flow_api.g_varchar2_table(21) := '66696C65735B305D2E6E616D65203A2022756E6B6E6F776E223B0A20202020617065782E7365727665722E706C7567696E2028206F7074696F6E732E616A61785F6964656E7469666965722C0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(22) := '207B207830313A206E616D652C0A20202020202020202020202020202020202020202020202020207830323A206F7074696F6E732E747970652C0A20202020202020202020202020202020202020202020202020206630313A20696D616765446174612E';
wwv_flow_api.g_varchar2_table(23) := '73706C697428226261736536342C22295B315D0A2020202020202020202020202020202020202020202020207D2C0A20202020202020202020202020207B0A2020202020202020202020202020202063616368653A2066616C73652C0A20202020202020';
wwv_flow_api.g_varchar2_table(24) := '20202020202020737563636573733A2066756E6374696F6E2820646174612029207B0A20202020202020202020202020202020617065782E64656275672E6C6F6728227375636365737322293B0A20202020202020202020202020202020242866696C65';
wwv_flow_api.g_varchar2_table(25) := '496E707574292E76616C282727293B0A2020202020202020202020202020202063616C6C6261636B28293B0A20202020202020202020202020207D0A202020207D293B0A0A20207D0A7D0A7D292820617065782E6A51756572792C20617065782E757469';
wwv_flow_api.g_varchar2_table(26) := '6C20293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(58965933194090754)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_file_name=>'at-cropit.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A212063726F706974202D2076302E352E31203C68747470733A2F2F6769746875622E636F6D2F73636F74746368656E672F63726F7069743E202A2F0A2866756E6374696F6E207765627061636B556E6976657273616C4D6F64756C65446566696E69';
wwv_flow_api.g_varchar2_table(2) := '74696F6E28726F6F742C20666163746F727929207B0A09696628747970656F66206578706F727473203D3D3D20276F626A6563742720262620747970656F66206D6F64756C65203D3D3D20276F626A65637427290A09096D6F64756C652E6578706F7274';
wwv_flow_api.g_varchar2_table(3) := '73203D20666163746F7279287265717569726528226A71756572792229293B0A09656C736520696628747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D64290A0909646566696E65285B226A717565';
wwv_flow_api.g_varchar2_table(4) := '7279225D2C20666163746F7279293B0A09656C736520696628747970656F66206578706F727473203D3D3D20276F626A65637427290A09096578706F7274735B2263726F706974225D203D20666163746F7279287265717569726528226A717565727922';
wwv_flow_api.g_varchar2_table(5) := '29293B0A09656C73650A0909726F6F745B2263726F706974225D203D20666163746F727928726F6F745B226A5175657279225D293B0A7D2928746869732C2066756E6374696F6E285F5F5745425041434B5F45585445524E414C5F4D4F44554C455F315F';
wwv_flow_api.g_varchar2_table(6) := '5F29207B0A72657475726E202F2A2A2A2A2A2A2F202866756E6374696F6E286D6F64756C657329207B202F2F207765627061636B426F6F7473747261700A2F2A2A2A2A2A2A2F20092F2F20546865206D6F64756C652063616368650A2F2A2A2A2A2A2A2F';
wwv_flow_api.g_varchar2_table(7) := '200976617220696E7374616C6C65644D6F64756C6573203D207B7D3B0A0A2F2A2A2A2A2A2A2F20092F2F2054686520726571756972652066756E6374696F6E0A2F2A2A2A2A2A2A2F200966756E6374696F6E205F5F7765627061636B5F72657175697265';
wwv_flow_api.g_varchar2_table(8) := '5F5F286D6F64756C65496429207B0A0A2F2A2A2A2A2A2A2F2009092F2F20436865636B206966206D6F64756C6520697320696E2063616368650A2F2A2A2A2A2A2A2F200909696628696E7374616C6C65644D6F64756C65735B6D6F64756C6549645D290A';
wwv_flow_api.g_varchar2_table(9) := '2F2A2A2A2A2A2A2F2009090972657475726E20696E7374616C6C65644D6F64756C65735B6D6F64756C6549645D2E6578706F7274733B0A0A2F2A2A2A2A2A2A2F2009092F2F204372656174652061206E6577206D6F64756C652028616E64207075742069';
wwv_flow_api.g_varchar2_table(10) := '7420696E746F20746865206361636865290A2F2A2A2A2A2A2A2F200909766172206D6F64756C65203D20696E7374616C6C65644D6F64756C65735B6D6F64756C6549645D203D207B0A2F2A2A2A2A2A2A2F200909096578706F7274733A207B7D2C0A2F2A';
wwv_flow_api.g_varchar2_table(11) := '2A2A2A2A2A2F2009090969643A206D6F64756C6549642C0A2F2A2A2A2A2A2A2F200909096C6F616465643A2066616C73650A2F2A2A2A2A2A2A2F2009097D3B0A0A2F2A2A2A2A2A2A2F2009092F2F204578656375746520746865206D6F64756C65206675';
wwv_flow_api.g_varchar2_table(12) := '6E6374696F6E0A2F2A2A2A2A2A2A2F2009096D6F64756C65735B6D6F64756C6549645D2E63616C6C286D6F64756C652E6578706F7274732C206D6F64756C652C206D6F64756C652E6578706F7274732C205F5F7765627061636B5F726571756972655F5F';
wwv_flow_api.g_varchar2_table(13) := '293B0A0A2F2A2A2A2A2A2A2F2009092F2F20466C616720746865206D6F64756C65206173206C6F616465640A2F2A2A2A2A2A2A2F2009096D6F64756C652E6C6F61646564203D20747275653B0A0A2F2A2A2A2A2A2A2F2009092F2F2052657475726E2074';
wwv_flow_api.g_varchar2_table(14) := '6865206578706F727473206F6620746865206D6F64756C650A2F2A2A2A2A2A2A2F20090972657475726E206D6F64756C652E6578706F7274733B0A2F2A2A2A2A2A2A2F20097D0A0A0A2F2A2A2A2A2A2A2F20092F2F206578706F736520746865206D6F64';
wwv_flow_api.g_varchar2_table(15) := '756C6573206F626A65637420285F5F7765627061636B5F6D6F64756C65735F5F290A2F2A2A2A2A2A2A2F20095F5F7765627061636B5F726571756972655F5F2E6D203D206D6F64756C65733B0A0A2F2A2A2A2A2A2A2F20092F2F206578706F7365207468';
wwv_flow_api.g_varchar2_table(16) := '65206D6F64756C652063616368650A2F2A2A2A2A2A2A2F20095F5F7765627061636B5F726571756972655F5F2E63203D20696E7374616C6C65644D6F64756C65733B0A0A2F2A2A2A2A2A2A2F20092F2F205F5F7765627061636B5F7075626C69635F7061';
wwv_flow_api.g_varchar2_table(17) := '74685F5F0A2F2A2A2A2A2A2A2F20095F5F7765627061636B5F726571756972655F5F2E70203D2022223B0A0A2F2A2A2A2A2A2A2F20092F2F204C6F616420656E747279206D6F64756C6520616E642072657475726E206578706F7274730A2F2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(18) := '2A2F200972657475726E205F5F7765627061636B5F726571756972655F5F2830293B0A2F2A2A2A2A2A2A2F207D290A2F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(19) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2F2A2A2A2A2A2A2F20285B0A2F2A2030202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F7274732C205F5F7765627061636B5F726571756972655F5F29207B0A0A0976';
wwv_flow_api.g_varchar2_table(20) := '6172205F736C696365203D2041727261792E70726F746F747970652E736C6963653B0A0A0966756E6374696F6E205F696E7465726F705265717569726544656661756C74286F626A29207B2072657475726E206F626A202626206F626A2E5F5F65734D6F';
wwv_flow_api.g_varchar2_table(21) := '64756C65203F206F626A203A207B202764656661756C74273A206F626A207D3B207D0A0A09766172205F6A7175657279203D205F5F7765627061636B5F726571756972655F5F2831293B0A0A09766172205F6A717565727932203D205F696E7465726F70';
wwv_flow_api.g_varchar2_table(22) := '5265717569726544656661756C74285F6A7175657279293B0A0A09766172205F63726F706974203D205F5F7765627061636B5F726571756972655F5F2832293B0A0A09766172205F63726F70697432203D205F696E7465726F7052657175697265446566';
wwv_flow_api.g_varchar2_table(23) := '61756C74285F63726F706974293B0A0A09766172205F636F6E7374616E7473203D205F5F7765627061636B5F726571756972655F5F2834293B0A0A09766172205F7574696C73203D205F5F7765627061636B5F726571756972655F5F2836293B0A0A0976';
wwv_flow_api.g_varchar2_table(24) := '6172206170706C794F6E45616368203D2066756E6374696F6E206170706C794F6E456163682824656C2C2063616C6C6261636B29207B0A09202072657475726E2024656C2E656163682866756E6374696F6E202829207B0A09202020207661722063726F';
wwv_flow_api.g_varchar2_table(25) := '706974203D205F6A7175657279325B2764656661756C74275D2E6461746128746869732C205F636F6E7374616E74732E504C5547494E5F4B4559293B0A0A0920202020696620282163726F70697429207B0A0920202020202072657475726E3B0A092020';
wwv_flow_api.g_varchar2_table(26) := '20207D0A092020202063616C6C6261636B2863726F706974293B0A0920207D293B0A097D3B0A0A097661722063616C6C4F6E4669727374203D2066756E6374696F6E2063616C6C4F6E46697273742824656C2C206D6574686F642C206F7074696F6E7329';
wwv_flow_api.g_varchar2_table(27) := '207B0A0920207661722063726F706974203D2024656C2E666972737428292E64617461285F636F6E7374616E74732E504C5547494E5F4B4559293B0A0A092020696620282163726F706974207C7C20215F6A7175657279325B2764656661756C74275D2E';
wwv_flow_api.g_varchar2_table(28) := '697346756E6374696F6E2863726F7069745B6D6574686F645D2929207B0A092020202072657475726E206E756C6C3B0A0920207D0A09202072657475726E2063726F7069745B6D6574686F645D286F7074696F6E73293B0A097D3B0A0A09766172206D65';
wwv_flow_api.g_varchar2_table(29) := '74686F6473203D207B0A092020696E69743A2066756E6374696F6E20696E6974286F7074696F6E7329207B0A092020202072657475726E20746869732E656163682866756E6374696F6E202829207B0A092020202020202F2F204F6E6C7920696E737461';
wwv_flow_api.g_varchar2_table(30) := '6E7469617465206F6E63652070657220656C656D656E740A09202020202020696620285F6A7175657279325B2764656661756C74275D2E6461746128746869732C205F636F6E7374616E74732E504C5547494E5F4B45592929207B0A0920202020202020';
wwv_flow_api.g_varchar2_table(31) := '2072657475726E3B0A092020202020207D0A0A092020202020207661722063726F706974203D206E6577205F63726F706974325B2764656661756C74275D285F6A7175657279325B2764656661756C74275D2C20746869732C206F7074696F6E73293B0A';
wwv_flow_api.g_varchar2_table(32) := '092020202020205F6A7175657279325B2764656661756C74275D2E6461746128746869732C205F636F6E7374616E74732E504C5547494E5F4B45592C2063726F706974293B0A09202020207D293B0A0920207D2C0A0A09202064657374726F793A206675';
wwv_flow_api.g_varchar2_table(33) := '6E6374696F6E2064657374726F792829207B0A092020202072657475726E20746869732E656163682866756E6374696F6E202829207B0A092020202020205F6A7175657279325B2764656661756C74275D2E72656D6F76654461746128746869732C205F';
wwv_flow_api.g_varchar2_table(34) := '636F6E7374616E74732E504C5547494E5F4B4559293B0A09202020207D293B0A0920207D2C0A0A09202069735A6F6F6D61626C653A2066756E6374696F6E2069735A6F6F6D61626C652829207B0A092020202072657475726E2063616C6C4F6E46697273';
wwv_flow_api.g_varchar2_table(35) := '7428746869732C202769735A6F6F6D61626C6527293B0A0920207D2C0A0A092020276578706F7274273A2066756E6374696F6E205F6578706F7274286F7074696F6E7329207B0A092020202072657475726E2063616C6C4F6E466972737428746869732C';
wwv_flow_api.g_varchar2_table(36) := '202767657443726F70706564496D61676544617461272C206F7074696F6E73293B0A0920207D0A097D3B0A0A097661722064656C6567617465203D2066756E6374696F6E2064656C65676174652824656C2C20666E4E616D6529207B0A09202072657475';
wwv_flow_api.g_varchar2_table(37) := '726E206170706C794F6E456163682824656C2C2066756E6374696F6E202863726F70697429207B0A092020202063726F7069745B666E4E616D655D28293B0A0920207D293B0A097D3B0A0A097661722070726F70203D2066756E6374696F6E2070726F70';
wwv_flow_api.g_varchar2_table(38) := '2824656C2C206E616D652C2076616C756529207B0A0920206966202828302C205F7574696C732E657869737473292876616C75652929207B0A092020202072657475726E206170706C794F6E456163682824656C2C2066756E6374696F6E202863726F70';
wwv_flow_api.g_varchar2_table(39) := '697429207B0A0920202020202063726F7069745B6E616D655D203D2076616C75653B0A09202020207D293B0A0920207D20656C7365207B0A09202020207661722063726F706974203D2024656C2E666972737428292E64617461285F636F6E7374616E74';
wwv_flow_api.g_varchar2_table(40) := '732E504C5547494E5F4B4559293B0A092020202072657475726E2063726F7069745B6E616D655D3B0A0920207D0A097D3B0A0A095F6A7175657279325B2764656661756C74275D2E666E2E63726F706974203D2066756E6374696F6E20286D6574686F64';
wwv_flow_api.g_varchar2_table(41) := '29207B0A092020696620286D6574686F64735B6D6574686F645D29207B0A092020202072657475726E206D6574686F64735B6D6574686F645D2E6170706C7928746869732C2041727261792E70726F746F747970652E736C6963652E63616C6C28617267';
wwv_flow_api.g_varchar2_table(42) := '756D656E74732C203129293B0A0920207D20656C736520696620285B27696D6167655374617465272C2027696D616765537263272C20276F6666736574272C20277072657669657753697A65272C2027696D61676553697A65272C20277A6F6F6D272C20';
wwv_flow_api.g_varchar2_table(43) := '27696E697469616C5A6F6F6D272C20276578706F72745A6F6F6D272C20276D696E5A6F6F6D272C20276D61785A6F6F6D275D2E696E6465784F66286D6574686F6429203E3D203029207B0A092020202072657475726E2070726F702E6170706C7928756E';
wwv_flow_api.g_varchar2_table(44) := '646566696E65642C205B746869735D2E636F6E636174285F736C6963652E63616C6C28617267756D656E74732929293B0A0920207D20656C736520696620285B27726F746174654357272C2027726F74617465434357272C202764697361626C65272C20';
wwv_flow_api.g_varchar2_table(45) := '277265656E61626C65275D2E696E6465784F66286D6574686F6429203E3D203029207B0A092020202072657475726E2064656C65676174652E6170706C7928756E646566696E65642C205B746869735D2E636F6E636174285F736C6963652E63616C6C28';
wwv_flow_api.g_varchar2_table(46) := '617267756D656E74732929293B0A0920207D20656C7365207B0A092020202072657475726E206D6574686F64732E696E69742E6170706C7928746869732C20617267756D656E7473293B0A0920207D0A097D3B0A0A2F2A2A2A2F207D2C0A2F2A2031202A';
wwv_flow_api.g_varchar2_table(47) := '2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F72747329207B0A0A096D6F64756C652E6578706F727473203D205F5F5745425041434B5F45585445524E414C5F4D4F44554C455F315F5F3B0A0A2F2A2A2A2F207D2C0A2F2A2032';
wwv_flow_api.g_varchar2_table(48) := '202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F7274732C205F5F7765627061636B5F726571756972655F5F29207B0A0A094F626A6563742E646566696E6550726F7065727479286578706F7274732C20275F5F65734D6F64';
wwv_flow_api.g_varchar2_table(49) := '756C65272C207B0A09202076616C75653A20747275650A097D293B0A0A09766172205F637265617465436C617373203D202866756E6374696F6E202829207B2066756E6374696F6E20646566696E6550726F70657274696573287461726765742C207072';
wwv_flow_api.g_varchar2_table(50) := '6F707329207B20666F7220287661722069203D20303B2069203C2070726F70732E6C656E6774683B20692B2B29207B207661722064657363726970746F72203D2070726F70735B695D3B2064657363726970746F722E656E756D657261626C65203D2064';
wwv_flow_api.g_varchar2_table(51) := '657363726970746F722E656E756D657261626C65207C7C2066616C73653B2064657363726970746F722E636F6E666967757261626C65203D20747275653B20696620282776616C75652720696E2064657363726970746F72292064657363726970746F72';
wwv_flow_api.g_varchar2_table(52) := '2E7772697461626C65203D20747275653B204F626A6563742E646566696E6550726F7065727479287461726765742C2064657363726970746F722E6B65792C2064657363726970746F72293B207D207D2072657475726E2066756E6374696F6E2028436F';
wwv_flow_api.g_varchar2_table(53) := '6E7374727563746F722C2070726F746F50726F70732C2073746174696350726F707329207B206966202870726F746F50726F70732920646566696E6550726F7065727469657328436F6E7374727563746F722E70726F746F747970652C2070726F746F50';
wwv_flow_api.g_varchar2_table(54) := '726F7073293B206966202873746174696350726F70732920646566696E6550726F7065727469657328436F6E7374727563746F722C2073746174696350726F7073293B2072657475726E20436F6E7374727563746F723B207D3B207D2928293B0A0A0966';
wwv_flow_api.g_varchar2_table(55) := '756E6374696F6E205F696E7465726F705265717569726544656661756C74286F626A29207B2072657475726E206F626A202626206F626A2E5F5F65734D6F64756C65203F206F626A203A207B202764656661756C74273A206F626A207D3B207D0A0A0966';
wwv_flow_api.g_varchar2_table(56) := '756E6374696F6E205F636C61737343616C6C436865636B28696E7374616E63652C20436F6E7374727563746F7229207B20696620282128696E7374616E636520696E7374616E63656F6620436F6E7374727563746F722929207B207468726F77206E6577';
wwv_flow_api.g_varchar2_table(57) := '20547970654572726F72282743616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E27293B207D207D0A0A09766172205F6A7175657279203D205F5F7765627061636B5F726571756972655F5F2831293B0A0A09766172205F';
wwv_flow_api.g_varchar2_table(58) := '6A717565727932203D205F696E7465726F705265717569726544656661756C74285F6A7175657279293B0A0A09766172205F5A6F6F6D6572203D205F5F7765627061636B5F726571756972655F5F2833293B0A0A09766172205F5A6F6F6D657232203D20';
wwv_flow_api.g_varchar2_table(59) := '5F696E7465726F705265717569726544656661756C74285F5A6F6F6D6572293B0A0A09766172205F636F6E7374616E7473203D205F5F7765627061636B5F726571756972655F5F2834293B0A0A09766172205F6F7074696F6E73203D205F5F7765627061';
wwv_flow_api.g_varchar2_table(60) := '636B5F726571756972655F5F2835293B0A0A09766172205F7574696C73203D205F5F7765627061636B5F726571756972655F5F2836293B0A0A097661722043726F706974203D202866756E6374696F6E202829207B0A09202066756E6374696F6E204372';
wwv_flow_api.g_varchar2_table(61) := '6F706974286A51756572792C20656C656D656E742C206F7074696F6E7329207B0A09202020205F636C61737343616C6C436865636B28746869732C2043726F706974293B0A0A0920202020746869732E24656C203D2028302C205F6A7175657279325B27';
wwv_flow_api.g_varchar2_table(62) := '64656661756C74275D2928656C656D656E74293B0A0A09202020207661722064656661756C7473203D2028302C205F6F7074696F6E732E6C6F616444656661756C74732928746869732E24656C293B0A0920202020746869732E6F7074696F6E73203D20';
wwv_flow_api.g_varchar2_table(63) := '5F6A7175657279325B2764656661756C74275D2E657874656E64287B7D2C2064656661756C74732C206F7074696F6E73293B0A0A0920202020746869732E696E697428293B0A0920207D0A0A0920205F637265617465436C6173732843726F7069742C20';
wwv_flow_api.g_varchar2_table(64) := '5B7B0A09202020206B65793A2027696E6974272C0A092020202076616C75653A2066756E6374696F6E20696E69742829207B0A09202020202020766172205F74686973203D20746869733B0A0A09202020202020746869732E696D616765203D206E6577';
wwv_flow_api.g_varchar2_table(65) := '20496D61676528293B0A09202020202020746869732E707265496D616765203D206E657720496D61676528293B0A09202020202020746869732E696D6167652E6F6E6C6F6164203D20746869732E6F6E496D6167654C6F616465642E62696E6428746869';
wwv_flow_api.g_varchar2_table(66) := '73293B0A09202020202020746869732E707265496D6167652E6F6E6C6F6164203D20746869732E6F6E507265496D6167654C6F616465642E62696E642874686973293B0A09202020202020746869732E696D6167652E6F6E6572726F72203D2074686973';
wwv_flow_api.g_varchar2_table(67) := '2E707265496D6167652E6F6E6572726F72203D2066756E6374696F6E202829207B0A0920202020202020205F746869732E6F6E496D6167654572726F722E63616C6C285F746869732C205F636F6E7374616E74732E4552524F52532E494D4147455F4641';
wwv_flow_api.g_varchar2_table(68) := '494C45445F544F5F4C4F4144293B0A092020202020207D3B0A0A09202020202020746869732E2470726576696577203D20746869732E6F7074696F6E732E24707265766965772E6373732827706F736974696F6E272C202772656C617469766527293B0A';
wwv_flow_api.g_varchar2_table(69) := '09202020202020746869732E2466696C65496E707574203D20746869732E6F7074696F6E732E2466696C65496E7075742E61747472287B206163636570743A2027696D6167652F2A27207D293B0A09202020202020746869732E247A6F6F6D536C696465';
wwv_flow_api.g_varchar2_table(70) := '72203D20746869732E6F7074696F6E732E247A6F6F6D536C696465722E61747472287B206D696E3A20302C206D61783A20312C20737465703A20302E3031207D293B0A0A09202020202020746869732E7072657669657753697A65203D207B0A09202020';
wwv_flow_api.g_varchar2_table(71) := '202020202077696474683A20746869732E6F7074696F6E732E7769647468207C7C20746869732E24707265766965772E696E6E6572576964746828292C0A0920202020202020206865696768743A20746869732E6F7074696F6E732E686569676874207C';
wwv_flow_api.g_varchar2_table(72) := '7C20746869732E24707265766965772E696E6E657248656967687428290A092020202020207D3B0A0A09202020202020746869732E24696D616765203D2028302C205F6A7175657279325B2764656661756C74275D2928273C696D67202F3E27292E6164';
wwv_flow_api.g_varchar2_table(73) := '64436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E505245564945575F494D414745292E617474722827616C74272C202727292E637373287B0A0920202020202020207472616E73666F726D4F726967696E3A2027746F70206C65';
wwv_flow_api.g_varchar2_table(74) := '6674272C0A0920202020202020207765626B69745472616E73666F726D4F726967696E3A2027746F70206C656674272C0A09202020202020202077696C6C4368616E67653A20277472616E73666F726D270A092020202020207D293B0A09202020202020';
wwv_flow_api.g_varchar2_table(75) := '746869732E24696D616765436F6E7461696E6572203D2028302C205F6A7175657279325B2764656661756C74275D2928273C646976202F3E27292E616464436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E505245564945575F49';
wwv_flow_api.g_varchar2_table(76) := '4D4147455F434F4E5441494E4552292E637373287B0A092020202020202020706F736974696F6E3A20276162736F6C757465272C0A0920202020202020206F766572666C6F773A202768696464656E272C0A0920202020202020206C6566743A20302C0A';
wwv_flow_api.g_varchar2_table(77) := '092020202020202020746F703A20302C0A09202020202020202077696474683A202731303025272C0A0920202020202020206865696768743A202731303025270A092020202020207D292E617070656E6428746869732E24696D616765293B0A09202020';
wwv_flow_api.g_varchar2_table(78) := '202020746869732E24707265766965772E617070656E6428746869732E24696D616765436F6E7461696E6572293B0A0A0920202020202069662028746869732E6F7074696F6E732E696D6167654261636B67726F756E6429207B0A092020202020202020';
wwv_flow_api.g_varchar2_table(79) := '696620285F6A7175657279325B2764656661756C74275D2E6973417272617928746869732E6F7074696F6E732E696D6167654261636B67726F756E64426F7264657257696474682929207B0A0920202020202020202020746869732E6267426F72646572';
wwv_flow_api.g_varchar2_table(80) := '57696474684172726179203D20746869732E6F7074696F6E732E696D6167654261636B67726F756E64426F7264657257696474683B0A0920202020202020207D20656C7365207B0A0920202020202020202020746869732E6267426F7264657257696474';
wwv_flow_api.g_varchar2_table(81) := '684172726179203D205B302C20312C20322C20335D2E6D61702866756E6374696F6E202829207B0A0920202020202020202020202072657475726E205F746869732E6F7074696F6E732E696D6167654261636B67726F756E64426F726465725769647468';
wwv_flow_api.g_varchar2_table(82) := '3B0A09202020202020202020207D293B0A0920202020202020207D0A0A092020202020202020746869732E246267203D2028302C205F6A7175657279325B2764656661756C74275D2928273C696D67202F3E27292E616464436C617373285F636F6E7374';
wwv_flow_api.g_varchar2_table(83) := '616E74732E434C4153535F4E414D45532E505245564945575F4241434B47524F554E44292E617474722827616C74272C202727292E637373287B0A0920202020202020202020706F736974696F6E3A202772656C6174697665272C0A0920202020202020';
wwv_flow_api.g_varchar2_table(84) := '2020206C6566743A20746869732E6267426F72646572576964746841727261795B335D2C0A0920202020202020202020746F703A20746869732E6267426F72646572576964746841727261795B305D2C0A09202020202020202020207472616E73666F72';
wwv_flow_api.g_varchar2_table(85) := '6D4F726967696E3A2027746F70206C656674272C0A09202020202020202020207765626B69745472616E73666F726D4F726967696E3A2027746F70206C656674272C0A092020202020202020202077696C6C4368616E67653A20277472616E73666F726D';
wwv_flow_api.g_varchar2_table(86) := '270A0920202020202020207D293B0A092020202020202020746869732E246267436F6E7461696E6572203D2028302C205F6A7175657279325B2764656661756C74275D2928273C646976202F3E27292E616464436C617373285F636F6E7374616E74732E';
wwv_flow_api.g_varchar2_table(87) := '434C4153535F4E414D45532E505245564945575F4241434B47524F554E445F434F4E5441494E4552292E637373287B0A0920202020202020202020706F736974696F6E3A20276162736F6C757465272C0A09202020202020202020207A496E6465783A20';
wwv_flow_api.g_varchar2_table(88) := '302C0A0920202020202020202020746F703A202D746869732E6267426F72646572576964746841727261795B305D2C0A092020202020202020202072696768743A202D746869732E6267426F72646572576964746841727261795B315D2C0A0920202020';
wwv_flow_api.g_varchar2_table(89) := '202020202020626F74746F6D3A202D746869732E6267426F72646572576964746841727261795B325D2C0A09202020202020202020206C6566743A202D746869732E6267426F72646572576964746841727261795B335D0A0920202020202020207D292E';
wwv_flow_api.g_varchar2_table(90) := '617070656E6428746869732E246267293B0A09202020202020202069662028746869732E6267426F72646572576964746841727261795B305D203E203029207B0A0920202020202020202020746869732E246267436F6E7461696E65722E63737328276F';
wwv_flow_api.g_varchar2_table(91) := '766572666C6F77272C202768696464656E27293B0A0920202020202020207D0A092020202020202020746869732E24707265766965772E70726570656E6428746869732E246267436F6E7461696E6572293B0A092020202020207D0A0A09202020202020';
wwv_flow_api.g_varchar2_table(92) := '746869732E696E697469616C5A6F6F6D203D20746869732E6F7074696F6E732E696E697469616C5A6F6F6D3B0A0A09202020202020746869732E696D6167654C6F61646564203D2066616C73653B0A0A09202020202020746869732E6D6F7665436F6E74';
wwv_flow_api.g_varchar2_table(93) := '696E7565203D2066616C73653B0A0A09202020202020746869732E7A6F6F6D6572203D206E6577205F5A6F6F6D6572325B2764656661756C74275D28293B0A0A0920202020202069662028746869732E6F7074696F6E732E616C6C6F77447261674E4472';
wwv_flow_api.g_varchar2_table(94) := '6F7029207B0A0920202020202020205F6A7175657279325B2764656661756C74275D2E6576656E742E70726F70732E707573682827646174615472616E7366657227293B0A092020202020207D0A0A09202020202020746869732E62696E644C69737465';
wwv_flow_api.g_varchar2_table(95) := '6E65727328293B0A0A0920202020202069662028746869732E6F7074696F6E732E696D616765537461746520262620746869732E6F7074696F6E732E696D61676553746174652E73726329207B0A092020202020202020746869732E6C6F6164496D6167';
wwv_flow_api.g_varchar2_table(96) := '6528746869732E6F7074696F6E732E696D61676553746174652E737263293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A202762696E644C697374656E657273272C0A092020202076616C75653A2066756E6374';
wwv_flow_api.g_varchar2_table(97) := '696F6E2062696E644C697374656E6572732829207B0A09202020202020746869732E2466696C65496E7075742E6F6E28276368616E67652E63726F706974272C20746869732E6F6E46696C654368616E67652E62696E64287468697329293B0A09202020';
wwv_flow_api.g_varchar2_table(98) := '202020746869732E24696D616765436F6E7461696E65722E6F6E285F636F6E7374616E74732E4556454E54532E505245564945572C20746869732E6F6E507265766965774576656E742E62696E64287468697329293B0A09202020202020746869732E24';
wwv_flow_api.g_varchar2_table(99) := '7A6F6F6D536C696465722E6F6E285F636F6E7374616E74732E4556454E54532E5A4F4F4D5F494E5055542C20746869732E6F6E5A6F6F6D536C696465724368616E67652E62696E64287468697329293B0A0A0920202020202069662028746869732E6F70';
wwv_flow_api.g_varchar2_table(100) := '74696F6E732E616C6C6F77447261674E44726F7029207B0A092020202020202020746869732E24696D616765436F6E7461696E65722E6F6E2827647261676F7665722E63726F70697420647261676C656176652E63726F706974272C20746869732E6F6E';
wwv_flow_api.g_varchar2_table(101) := '447261674F7665722E62696E64287468697329293B0A092020202020202020746869732E24696D616765436F6E7461696E65722E6F6E282764726F702E63726F706974272C20746869732E6F6E44726F702E62696E64287468697329293B0A0920202020';
wwv_flow_api.g_varchar2_table(102) := '20207D0A09202020207D0A0920207D2C207B0A09202020206B65793A2027756E62696E644C697374656E657273272C0A092020202076616C75653A2066756E6374696F6E20756E62696E644C697374656E6572732829207B0A0920202020202074686973';
wwv_flow_api.g_varchar2_table(103) := '2E2466696C65496E7075742E6F666628276368616E67652E63726F70697427293B0A09202020202020746869732E24696D616765436F6E7461696E65722E6F6666285F636F6E7374616E74732E4556454E54532E50524556494557293B0A092020202020';
wwv_flow_api.g_varchar2_table(104) := '20746869732E24696D616765436F6E7461696E65722E6F66662827647261676F7665722E63726F70697420647261676C656176652E63726F7069742064726F702E63726F70697427293B0A09202020202020746869732E247A6F6F6D536C696465722E6F';
wwv_flow_api.g_varchar2_table(105) := '6666285F636F6E7374616E74732E4556454E54532E5A4F4F4D5F494E505554293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E46696C654368616E6765272C0A092020202076616C75653A2066756E6374696F6E206F6E4669';
wwv_flow_api.g_varchar2_table(106) := '6C654368616E6765286529207B0A09202020202020746869732E6F7074696F6E732E6F6E46696C654368616E67652865293B0A0A0920202020202069662028746869732E2466696C65496E7075742E6765742830292E66696C657329207B0A0920202020';
wwv_flow_api.g_varchar2_table(107) := '20202020746869732E6C6F616446696C6528746869732E2466696C65496E7075742E6765742830292E66696C65735B305D293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A20276C6F616446696C65272C0A0920';
wwv_flow_api.g_varchar2_table(108) := '20202076616C75653A2066756E6374696F6E206C6F616446696C652866696C6529207B0A092020202020207661722066696C65526561646572203D206E65772046696C6552656164657228293B0A092020202020206966202866696C652026262066696C';
wwv_flow_api.g_varchar2_table(109) := '652E747970652E6D617463682827696D616765272929207B0A09202020202020202066696C655265616465722E7265616441734461746155524C2866696C65293B0A09202020202020202066696C655265616465722E6F6E6C6F6164203D20746869732E';
wwv_flow_api.g_varchar2_table(110) := '6F6E46696C655265616465724C6F616465642E62696E642874686973293B0A09202020202020202066696C655265616465722E6F6E6572726F72203D20746869732E6F6E46696C655265616465724572726F722E62696E642874686973293B0A09202020';
wwv_flow_api.g_varchar2_table(111) := '2020207D20656C7365206966202866696C6529207B0A092020202020202020746869732E6F6E46696C655265616465724572726F7228293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E46696C655265';
wwv_flow_api.g_varchar2_table(112) := '616465724C6F61646564272C0A092020202076616C75653A2066756E6374696F6E206F6E46696C655265616465724C6F61646564286529207B0A09202020202020746869732E6C6F6164496D61676528652E7461726765742E726573756C74293B0A0920';
wwv_flow_api.g_varchar2_table(113) := '2020207D0A0920207D2C207B0A09202020206B65793A20276F6E46696C655265616465724572726F72272C0A092020202076616C75653A2066756E6374696F6E206F6E46696C655265616465724572726F722829207B0A09202020202020746869732E6F';
wwv_flow_api.g_varchar2_table(114) := '7074696F6E732E6F6E46696C655265616465724572726F7228293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E447261674F766572272C0A092020202076616C75653A2066756E6374696F6E206F6E447261674F7665722865';
wwv_flow_api.g_varchar2_table(115) := '29207B0A09202020202020652E70726576656E7444656661756C7428293B0A09202020202020652E646174615472616E736665722E64726F70456666656374203D2027636F7079273B0A09202020202020746869732E24707265766965772E746F67676C';
wwv_flow_api.g_varchar2_table(116) := '65436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E445241475F484F56455245442C20652E74797065203D3D3D2027647261676F76657227293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E44726F70';
wwv_flow_api.g_varchar2_table(117) := '272C0A092020202076616C75653A2066756E6374696F6E206F6E44726F70286529207B0A09202020202020766172205F7468697332203D20746869733B0A0A09202020202020652E70726576656E7444656661756C7428293B0A09202020202020652E73';
wwv_flow_api.g_varchar2_table(118) := '746F7050726F7061676174696F6E28293B0A0A092020202020207661722066696C6573203D2041727261792E70726F746F747970652E736C6963652E63616C6C28652E646174615472616E736665722E66696C65732C2030293B0A092020202020206669';
wwv_flow_api.g_varchar2_table(119) := '6C65732E736F6D652866756E6374696F6E202866696C6529207B0A092020202020202020696620282166696C652E747970652E6D617463682827696D616765272929207B0A092020202020202020202072657475726E2066616C73653B0A092020202020';
wwv_flow_api.g_varchar2_table(120) := '2020207D0A0A0920202020202020205F74686973322E6C6F616446696C652866696C65293B0A09202020202020202072657475726E20747275653B0A092020202020207D293B0A0A09202020202020746869732E24707265766965772E72656D6F766543';
wwv_flow_api.g_varchar2_table(121) := '6C617373285F636F6E7374616E74732E434C4153535F4E414D45532E445241475F484F5645524544293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276C6F6164496D616765272C0A092020202076616C75653A2066756E6374696F';
wwv_flow_api.g_varchar2_table(122) := '6E206C6F6164496D61676528696D61676553726329207B0A09202020202020766172205F7468697333203D20746869733B0A0A092020202020206966202821696D61676553726329207B0A09202020202020202072657475726E3B0A092020202020207D';
wwv_flow_api.g_varchar2_table(123) := '0A0A09202020202020746869732E6F7074696F6E732E6F6E496D6167654C6F6164696E6728293B0A09202020202020746869732E736574496D6167654C6F6164696E67436C61737328293B0A0A0920202020202069662028696D6167655372632E696E64';
wwv_flow_api.g_varchar2_table(124) := '65784F662827646174612729203D3D3D203029207B0A092020202020202020746869732E707265496D6167652E737263203D20696D6167655372633B0A092020202020207D20656C7365207B0A09202020202020202076617220786872203D206E657720';
wwv_flow_api.g_varchar2_table(125) := '584D4C487474705265717565737428293B0A0920202020202020207868722E6F6E6C6F6164203D2066756E6374696F6E20286529207B0A092020202020202020202069662028652E7461726765742E737461747573203E3D2033303029207B0A09202020';
wwv_flow_api.g_varchar2_table(126) := '2020202020202020205F74686973332E6F6E496D6167654572726F722E63616C6C285F74686973332C205F636F6E7374616E74732E4552524F52532E494D4147455F4641494C45445F544F5F4C4F4144293B0A0920202020202020202020202072657475';
wwv_flow_api.g_varchar2_table(127) := '726E3B0A09202020202020202020207D0A0A09202020202020202020205F74686973332E6C6F616446696C6528652E7461726765742E726573706F6E7365293B0A0920202020202020207D3B0A0920202020202020207868722E6F70656E282747455427';
wwv_flow_api.g_varchar2_table(128) := '2C20696D616765537263293B0A0920202020202020207868722E726573706F6E736554797065203D2027626C6F62273B0A0920202020202020207868722E73656E6428293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B';
wwv_flow_api.g_varchar2_table(129) := '65793A20276F6E507265496D6167654C6F61646564272C0A092020202076616C75653A2066756E6374696F6E206F6E507265496D6167654C6F616465642829207B0A0920202020202069662028746869732E73686F756C6452656A656374496D61676528';
wwv_flow_api.g_varchar2_table(130) := '7B0A092020202020202020696D61676557696474683A20746869732E707265496D6167652E77696474682C0A092020202020202020696D6167654865696768743A20746869732E707265496D6167652E6865696768742C0A092020202020202020707265';
wwv_flow_api.g_varchar2_table(131) := '7669657753697A653A20746869732E7072657669657753697A652C0A0920202020202020206D61785A6F6F6D3A20746869732E6F7074696F6E732E6D61785A6F6F6D2C0A0920202020202020206578706F72745A6F6F6D3A20746869732E6F7074696F6E';
wwv_flow_api.g_varchar2_table(132) := '732E6578706F72745A6F6F6D2C0A092020202020202020736D616C6C496D6167653A20746869732E6F7074696F6E732E736D616C6C496D6167650A092020202020207D2929207B0A092020202020202020746869732E6F6E496D6167654572726F72285F';
wwv_flow_api.g_varchar2_table(133) := '636F6E7374616E74732E4552524F52532E534D414C4C5F494D414745293B0A09202020202020202069662028746869732E696D6167652E73726329207B0A0920202020202020202020746869732E736574496D6167654C6F61646564436C61737328293B';
wwv_flow_api.g_varchar2_table(134) := '0A0920202020202020207D0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020746869732E696D6167652E737263203D20746869732E707265496D6167652E7372633B0A09202020207D0A0920207D2C207B0A092020';
wwv_flow_api.g_varchar2_table(135) := '20206B65793A20276F6E496D6167654C6F61646564272C0A092020202076616C75653A2066756E6374696F6E206F6E496D6167654C6F616465642829207B0A09202020202020746869732E726F746174696F6E203D20303B0A0920202020202074686973';
wwv_flow_api.g_varchar2_table(136) := '2E73657475705A6F6F6D657228746869732E6F7074696F6E732E696D616765537461746520262620746869732E6F7074696F6E732E696D61676553746174652E7A6F6F6D207C7C20746869732E5F696E697469616C5A6F6F6D293B0A0920202020202069';
wwv_flow_api.g_varchar2_table(137) := '662028746869732E6F7074696F6E732E696D616765537461746520262620746869732E6F7074696F6E732E696D61676553746174652E6F666673657429207B0A092020202020202020746869732E6F6666736574203D20746869732E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(138) := '696D61676553746174652E6F66667365743B0A092020202020207D20656C7365207B0A092020202020202020746869732E63656E746572496D61676528293B0A092020202020207D0A0A09202020202020746869732E6F7074696F6E732E696D61676553';
wwv_flow_api.g_varchar2_table(139) := '74617465203D207B7D3B0A0A09202020202020746869732E24696D6167652E617474722827737263272C20746869732E696D6167652E737263293B0A0920202020202069662028746869732E6F7074696F6E732E696D6167654261636B67726F756E6429';
wwv_flow_api.g_varchar2_table(140) := '207B0A092020202020202020746869732E2462672E617474722827737263272C20746869732E696D6167652E737263293B0A092020202020207D0A0A09202020202020746869732E736574496D6167654C6F61646564436C61737328293B0A0A09202020';
wwv_flow_api.g_varchar2_table(141) := '202020746869732E696D6167654C6F61646564203D20747275653B0A0A09202020202020746869732E6F7074696F6E732E6F6E496D6167654C6F6164656428293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E496D61676545';
wwv_flow_api.g_varchar2_table(142) := '72726F72272C0A092020202076616C75653A2066756E6374696F6E206F6E496D6167654572726F722829207B0A09202020202020746869732E6F7074696F6E732E6F6E496D6167654572726F722E6170706C7928746869732C20617267756D656E747329';
wwv_flow_api.g_varchar2_table(143) := '3B0A09202020202020746869732E72656D6F7665496D6167654C6F6164696E67436C61737328293B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027736574496D6167654C6F6164696E67436C617373272C0A092020202076616C7565';
wwv_flow_api.g_varchar2_table(144) := '3A2066756E6374696F6E20736574496D6167654C6F6164696E67436C6173732829207B0A09202020202020746869732E24707265766965772E72656D6F7665436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E494D4147455F4C4F';
wwv_flow_api.g_varchar2_table(145) := '41444544292E616464436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E494D4147455F4C4F4144494E47293B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027736574496D6167654C6F61646564436C61737327';
wwv_flow_api.g_varchar2_table(146) := '2C0A092020202076616C75653A2066756E6374696F6E20736574496D6167654C6F61646564436C6173732829207B0A09202020202020746869732E24707265766965772E72656D6F7665436C617373285F636F6E7374616E74732E434C4153535F4E414D';
wwv_flow_api.g_varchar2_table(147) := '45532E494D4147455F4C4F4144494E47292E616464436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E494D4147455F4C4F41444544293B0A09202020207D0A0920207D2C207B0A09202020206B65793A202772656D6F7665496D61';
wwv_flow_api.g_varchar2_table(148) := '67654C6F6164696E67436C617373272C0A092020202076616C75653A2066756E6374696F6E2072656D6F7665496D6167654C6F6164696E67436C6173732829207B0A09202020202020746869732E24707265766965772E72656D6F7665436C617373285F';
wwv_flow_api.g_varchar2_table(149) := '636F6E7374616E74732E434C4153535F4E414D45532E494D4147455F4C4F4144494E47293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276765744576656E74506F736974696F6E272C0A092020202076616C75653A2066756E6374';
wwv_flow_api.g_varchar2_table(150) := '696F6E206765744576656E74506F736974696F6E286529207B0A0920202020202069662028652E6F726967696E616C4576656E7420262620652E6F726967696E616C4576656E742E746F756368657320262620652E6F726967696E616C4576656E742E74';
wwv_flow_api.g_varchar2_table(151) := '6F75636865735B305D29207B0A09202020202020202065203D20652E6F726967696E616C4576656E742E746F75636865735B305D3B0A092020202020207D0A0920202020202069662028652E636C69656E745820262620652E636C69656E745929207B0A';
wwv_flow_api.g_varchar2_table(152) := '09202020202020202072657475726E207B20783A20652E636C69656E74582C20793A20652E636C69656E7459207D3B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E507265766965774576656E74272C0A';
wwv_flow_api.g_varchar2_table(153) := '092020202076616C75653A2066756E6374696F6E206F6E507265766965774576656E74286529207B0A092020202020206966202821746869732E696D6167654C6F6164656429207B0A09202020202020202072657475726E3B0A092020202020207D0A0A';
wwv_flow_api.g_varchar2_table(154) := '09202020202020746869732E6D6F7665436F6E74696E7565203D2066616C73653B0A09202020202020746869732E24696D616765436F6E7461696E65722E6F6666285F636F6E7374616E74732E4556454E54532E505245564945575F4D4F5645293B0A0A';
wwv_flow_api.g_varchar2_table(155) := '0920202020202069662028652E74797065203D3D3D20276D6F757365646F776E27207C7C20652E74797065203D3D3D2027746F75636873746172742729207B0A092020202020202020746869732E6F726967696E203D20746869732E6765744576656E74';
wwv_flow_api.g_varchar2_table(156) := '506F736974696F6E2865293B0A092020202020202020746869732E6D6F7665436F6E74696E7565203D20747275653B0A092020202020202020746869732E24696D616765436F6E7461696E65722E6F6E285F636F6E7374616E74732E4556454E54532E50';
wwv_flow_api.g_varchar2_table(157) := '5245564945575F4D4F56452C20746869732E6F6E4D6F76652E62696E64287468697329293B0A092020202020207D20656C7365207B0A09202020202020202028302C205F6A7175657279325B2764656661756C74275D2928646F63756D656E742E626F64';
wwv_flow_api.g_varchar2_table(158) := '79292E666F63757328293B0A092020202020207D0A0A09202020202020652E73746F7050726F7061676174696F6E28293B0A0920202020202072657475726E2066616C73653B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E4D';
wwv_flow_api.g_varchar2_table(159) := '6F7665272C0A092020202076616C75653A2066756E6374696F6E206F6E4D6F7665286529207B0A09202020202020766172206576656E74506F736974696F6E203D20746869732E6765744576656E74506F736974696F6E2865293B0A0A09202020202020';
wwv_flow_api.g_varchar2_table(160) := '69662028746869732E6D6F7665436F6E74696E7565202626206576656E74506F736974696F6E29207B0A092020202020202020746869732E6F6666736574203D207B0A0920202020202020202020783A20746869732E6F66667365742E78202B20657665';
wwv_flow_api.g_varchar2_table(161) := '6E74506F736974696F6E2E78202D20746869732E6F726967696E2E782C0A0920202020202020202020793A20746869732E6F66667365742E79202B206576656E74506F736974696F6E2E79202D20746869732E6F726967696E2E790A0920202020202020';
wwv_flow_api.g_varchar2_table(162) := '207D3B0A092020202020207D0A0A09202020202020746869732E6F726967696E203D206576656E74506F736974696F6E3B0A0A09202020202020652E73746F7050726F7061676174696F6E28293B0A0920202020202072657475726E2066616C73653B0A';
wwv_flow_api.g_varchar2_table(163) := '09202020207D0A0920207D2C207B0A09202020206B65793A20276669784F6666736574272C0A092020202076616C75653A2066756E6374696F6E206669784F6666736574286F666673657429207B0A092020202020206966202821746869732E696D6167';
wwv_flow_api.g_varchar2_table(164) := '654C6F6164656429207B0A09202020202020202072657475726E206F66667365743B0A092020202020207D0A0A0920202020202076617220726574203D207B20783A206F66667365742E782C20793A206F66667365742E79207D3B0A0A09202020202020';
wwv_flow_api.g_varchar2_table(165) := '6966202821746869732E6F7074696F6E732E667265654D6F766529207B0A09202020202020202069662028746869732E696D6167655769647468202A20746869732E7A6F6F6D203E3D20746869732E7072657669657753697A652E776964746829207B0A';
wwv_flow_api.g_varchar2_table(166) := '09202020202020202020207265742E78203D204D6174682E6D696E28302C204D6174682E6D6178287265742E782C20746869732E7072657669657753697A652E7769647468202D20746869732E696D6167655769647468202A20746869732E7A6F6F6D29';
wwv_flow_api.g_varchar2_table(167) := '293B0A0920202020202020207D20656C7365207B0A09202020202020202020207265742E78203D204D6174682E6D617828302C204D6174682E6D696E287265742E782C20746869732E7072657669657753697A652E7769647468202D20746869732E696D';
wwv_flow_api.g_varchar2_table(168) := '6167655769647468202A20746869732E7A6F6F6D29293B0A0920202020202020207D0A0A09202020202020202069662028746869732E696D616765486569676874202A20746869732E7A6F6F6D203E3D20746869732E7072657669657753697A652E6865';
wwv_flow_api.g_varchar2_table(169) := '6967687429207B0A09202020202020202020207265742E79203D204D6174682E6D696E28302C204D6174682E6D6178287265742E792C20746869732E7072657669657753697A652E686569676874202D20746869732E696D616765486569676874202A20';
wwv_flow_api.g_varchar2_table(170) := '746869732E7A6F6F6D29293B0A0920202020202020207D20656C7365207B0A09202020202020202020207265742E79203D204D6174682E6D617828302C204D6174682E6D696E287265742E792C20746869732E7072657669657753697A652E6865696768';
wwv_flow_api.g_varchar2_table(171) := '74202D20746869732E696D616765486569676874202A20746869732E7A6F6F6D29293B0A0920202020202020207D0A092020202020207D0A0A092020202020207265742E78203D2028302C205F7574696C732E726F756E6429287265742E78293B0A0920';
wwv_flow_api.g_varchar2_table(172) := '20202020207265742E79203D2028302C205F7574696C732E726F756E6429287265742E79293B0A0A0920202020202072657475726E207265743B0A09202020207D0A0920207D2C207B0A09202020206B65793A202763656E746572496D616765272C0A09';
wwv_flow_api.g_varchar2_table(173) := '2020202076616C75653A2066756E6374696F6E2063656E746572496D6167652829207B0A092020202020206966202821746869732E696D6167652E7769647468207C7C2021746869732E696D6167652E686569676874207C7C2021746869732E7A6F6F6D';
wwv_flow_api.g_varchar2_table(174) := '29207B0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020746869732E6F6666736574203D207B0A092020202020202020783A2028746869732E7072657669657753697A652E7769647468202D20746869732E696D61';
wwv_flow_api.g_varchar2_table(175) := '67655769647468202A20746869732E7A6F6F6D29202F20322C0A092020202020202020793A2028746869732E7072657669657753697A652E686569676874202D20746869732E696D616765486569676874202A20746869732E7A6F6F6D29202F20320A09';
wwv_flow_api.g_varchar2_table(176) := '2020202020207D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6E5A6F6F6D536C696465724368616E6765272C0A092020202076616C75653A2066756E6374696F6E206F6E5A6F6F6D536C696465724368616E67652829207B0A';
wwv_flow_api.g_varchar2_table(177) := '092020202020206966202821746869732E696D6167654C6F6164656429207B0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020746869732E7A6F6F6D536C69646572506F73203D204E756D62657228746869732E24';
wwv_flow_api.g_varchar2_table(178) := '7A6F6F6D536C696465722E76616C2829293B0A09202020202020766172206E65775A6F6F6D203D20746869732E7A6F6F6D65722E6765745A6F6F6D28746869732E7A6F6F6D536C69646572506F73293B0A09202020202020696620286E65775A6F6F6D20';
wwv_flow_api.g_varchar2_table(179) := '3D3D3D20746869732E7A6F6F6D29207B0A09202020202020202072657475726E3B0A092020202020207D0A09202020202020746869732E7A6F6F6D203D206E65775A6F6F6D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027656E61';
wwv_flow_api.g_varchar2_table(180) := '626C655A6F6F6D536C69646572272C0A092020202076616C75653A2066756E6374696F6E20656E61626C655A6F6F6D536C696465722829207B0A09202020202020746869732E247A6F6F6D536C696465722E72656D6F766541747472282764697361626C';
wwv_flow_api.g_varchar2_table(181) := '656427293B0A09202020202020746869732E6F7074696F6E732E6F6E5A6F6F6D456E61626C656428293B0A09202020207D0A0920207D2C207B0A09202020206B65793A202764697361626C655A6F6F6D536C69646572272C0A092020202076616C75653A';
wwv_flow_api.g_varchar2_table(182) := '2066756E6374696F6E2064697361626C655A6F6F6D536C696465722829207B0A09202020202020746869732E247A6F6F6D536C696465722E61747472282764697361626C6564272C2074727565293B0A09202020202020746869732E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(183) := '6F6E5A6F6F6D44697361626C656428293B0A09202020207D0A0920207D2C207B0A09202020206B65793A202773657475705A6F6F6D6572272C0A092020202076616C75653A2066756E6374696F6E2073657475705A6F6F6D6572287A6F6F6D29207B0A09';
wwv_flow_api.g_varchar2_table(184) := '202020202020746869732E7A6F6F6D65722E7365747570287B0A092020202020202020696D61676553697A653A20746869732E696D61676553697A652C0A0920202020202020207072657669657753697A653A20746869732E7072657669657753697A65';
wwv_flow_api.g_varchar2_table(185) := '2C0A0920202020202020206578706F72745A6F6F6D3A20746869732E6F7074696F6E732E6578706F72745A6F6F6D2C0A0920202020202020206D61785A6F6F6D3A20746869732E6F7074696F6E732E6D61785A6F6F6D2C0A0920202020202020206D696E';
wwv_flow_api.g_varchar2_table(186) := '5A6F6F6D3A20746869732E6F7074696F6E732E6D696E5A6F6F6D2C0A092020202020202020736D616C6C496D6167653A20746869732E6F7074696F6E732E736D616C6C496D6167650A092020202020207D293B0A09202020202020746869732E7A6F6F6D';
wwv_flow_api.g_varchar2_table(187) := '203D2028302C205F7574696C732E65786973747329287A6F6F6D29203F207A6F6F6D203A20746869732E5F7A6F6F6D3B0A0A0920202020202069662028746869732E69735A6F6F6D61626C65282929207B0A092020202020202020746869732E656E6162';
wwv_flow_api.g_varchar2_table(188) := '6C655A6F6F6D536C6964657228293B0A092020202020207D20656C7365207B0A092020202020202020746869732E64697361626C655A6F6F6D536C6964657228293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A';
wwv_flow_api.g_varchar2_table(189) := '20276669785A6F6F6D272C0A092020202076616C75653A2066756E6374696F6E206669785A6F6F6D287A6F6F6D29207B0A0920202020202072657475726E20746869732E7A6F6F6D65722E6669785A6F6F6D287A6F6F6D293B0A09202020207D0A092020';
wwv_flow_api.g_varchar2_table(190) := '7D2C207B0A09202020206B65793A202769735A6F6F6D61626C65272C0A092020202076616C75653A2066756E6374696F6E2069735A6F6F6D61626C652829207B0A0920202020202072657475726E20746869732E7A6F6F6D65722E69735A6F6F6D61626C';
wwv_flow_api.g_varchar2_table(191) := '6528293B0A09202020207D0A0920207D2C207B0A09202020206B65793A202772656E646572496D616765272C0A092020202076616C75653A2066756E6374696F6E2072656E646572496D6167652829207B0A09202020202020766172207472616E73666F';
wwv_flow_api.g_varchar2_table(192) := '726D6174696F6E203D20275C6E2020202020207472616E736C6174652827202B20746869732E726F74617465644F66667365742E78202B202770782C2027202B20746869732E726F74617465644F66667365742E79202B20277078295C6E202020202020';
wwv_flow_api.g_varchar2_table(193) := '7363616C652827202B20746869732E7A6F6F6D202B2027295C6E202020202020726F746174652827202B20746869732E726F746174696F6E202B202764656729273B0A0A09202020202020746869732E24696D6167652E637373287B0A09202020202020';
wwv_flow_api.g_varchar2_table(194) := '20207472616E73666F726D3A207472616E73666F726D6174696F6E2C0A0920202020202020207765626B69745472616E73666F726D3A207472616E73666F726D6174696F6E0A092020202020207D293B0A0920202020202069662028746869732E6F7074';
wwv_flow_api.g_varchar2_table(195) := '696F6E732E696D6167654261636B67726F756E6429207B0A092020202020202020746869732E2462672E637373287B0A09202020202020202020207472616E73666F726D3A207472616E73666F726D6174696F6E2C0A0920202020202020202020776562';
wwv_flow_api.g_varchar2_table(196) := '6B69745472616E73666F726D3A207472616E73666F726D6174696F6E0A0920202020202020207D293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A2027726F746174654357272C0A092020202076616C75653A20';
wwv_flow_api.g_varchar2_table(197) := '66756E6374696F6E20726F7461746543572829207B0A0920202020202069662028746869732E73686F756C6452656A656374496D616765287B0A092020202020202020696D61676557696474683A20746869732E696D6167652E6865696768742C0A0920';
wwv_flow_api.g_varchar2_table(198) := '20202020202020696D6167654865696768743A20746869732E696D6167652E77696474682C0A0920202020202020207072657669657753697A653A20746869732E7072657669657753697A652C0A0920202020202020206D61785A6F6F6D3A2074686973';
wwv_flow_api.g_varchar2_table(199) := '2E6F7074696F6E732E6D61785A6F6F6D2C0A0920202020202020206578706F72745A6F6F6D3A20746869732E6F7074696F6E732E6578706F72745A6F6F6D2C0A092020202020202020736D616C6C496D6167653A20746869732E6F7074696F6E732E736D';
wwv_flow_api.g_varchar2_table(200) := '616C6C496D6167650A092020202020207D2929207B0A092020202020202020746869732E726F746174696F6E203D2028746869732E726F746174696F6E202B20313830292025203336303B0A092020202020207D20656C7365207B0A0920202020202020';
wwv_flow_api.g_varchar2_table(201) := '20746869732E726F746174696F6E203D2028746869732E726F746174696F6E202B203930292025203336303B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A2027726F74617465434357272C0A092020202076616C';
wwv_flow_api.g_varchar2_table(202) := '75653A2066756E6374696F6E20726F746174654343572829207B0A0920202020202069662028746869732E73686F756C6452656A656374496D616765287B0A092020202020202020696D61676557696474683A20746869732E696D6167652E6865696768';
wwv_flow_api.g_varchar2_table(203) := '742C0A092020202020202020696D6167654865696768743A20746869732E696D6167652E77696474682C0A0920202020202020207072657669657753697A653A20746869732E7072657669657753697A652C0A0920202020202020206D61785A6F6F6D3A';
wwv_flow_api.g_varchar2_table(204) := '20746869732E6F7074696F6E732E6D61785A6F6F6D2C0A0920202020202020206578706F72745A6F6F6D3A20746869732E6F7074696F6E732E6578706F72745A6F6F6D2C0A092020202020202020736D616C6C496D6167653A20746869732E6F7074696F';
wwv_flow_api.g_varchar2_table(205) := '6E732E736D616C6C496D6167650A092020202020207D2929207B0A092020202020202020746869732E726F746174696F6E203D2028746869732E726F746174696F6E202B20313830292025203336303B0A092020202020207D20656C7365207B0A092020';
wwv_flow_api.g_varchar2_table(206) := '202020202020746869732E726F746174696F6E203D2028746869732E726F746174696F6E202B20323730292025203336303B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A202773686F756C6452656A656374496D';
wwv_flow_api.g_varchar2_table(207) := '616765272C0A092020202076616C75653A2066756E6374696F6E2073686F756C6452656A656374496D616765285F72656629207B0A0920202020202076617220696D6167655769647468203D205F7265662E696D61676557696474683B0A092020202020';
wwv_flow_api.g_varchar2_table(208) := '2076617220696D616765486569676874203D205F7265662E696D6167654865696768743B0A09202020202020766172207072657669657753697A65203D205F7265662E7072657669657753697A653B0A09202020202020766172206D61785A6F6F6D203D';
wwv_flow_api.g_varchar2_table(209) := '205F7265662E6D61785A6F6F6D3B0A09202020202020766172206578706F72745A6F6F6D203D205F7265662E6578706F72745A6F6F6D3B0A0920202020202076617220736D616C6C496D616765203D205F7265662E736D616C6C496D6167653B0A0A0920';
wwv_flow_api.g_varchar2_table(210) := '202020202069662028736D616C6C496D61676520213D3D202772656A6563742729207B0A09202020202020202072657475726E2066616C73653B0A092020202020207D0A0A0920202020202072657475726E20696D6167655769647468202A206D61785A';
wwv_flow_api.g_varchar2_table(211) := '6F6F6D203C207072657669657753697A652E7769647468202A206578706F72745A6F6F6D207C7C20696D616765486569676874202A206D61785A6F6F6D203C207072657669657753697A652E686569676874202A206578706F72745A6F6F6D3B0A092020';
wwv_flow_api.g_varchar2_table(212) := '20207D0A0920207D2C207B0A09202020206B65793A202767657443726F70706564496D61676544617461272C0A092020202076616C75653A2066756E6374696F6E2067657443726F70706564496D61676544617461286578706F72744F7074696F6E7329';
wwv_flow_api.g_varchar2_table(213) := '207B0A092020202020206966202821746869732E696D6167652E73726329207B0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020766172206578706F727444656661756C7473203D207B0A09202020202020202074';
wwv_flow_api.g_varchar2_table(214) := '7970653A2027696D6167652F706E67272C0A0920202020202020207175616C6974793A20302E37352C0A0920202020202020206F726967696E616C53697A653A2066616C73652C0A09202020202020202066696C6C42673A202723666666270A09202020';
wwv_flow_api.g_varchar2_table(215) := '2020207D3B0A092020202020206578706F72744F7074696F6E73203D205F6A7175657279325B2764656661756C74275D2E657874656E64287B7D2C206578706F727444656661756C74732C206578706F72744F7074696F6E73293B0A0A09202020202020';
wwv_flow_api.g_varchar2_table(216) := '766172206578706F72745A6F6F6D203D206578706F72744F7074696F6E732E6F726967696E616C53697A65203F2031202F20746869732E7A6F6F6D203A20746869732E6F7074696F6E732E6578706F72745A6F6F6D3B0A0A09202020202020766172207A';
wwv_flow_api.g_varchar2_table(217) := '6F6F6D656453697A65203D207B0A09202020202020202077696474683A20746869732E7A6F6F6D202A206578706F72745A6F6F6D202A20746869732E696D6167652E77696474682C0A0920202020202020206865696768743A20746869732E7A6F6F6D20';
wwv_flow_api.g_varchar2_table(218) := '2A206578706F72745A6F6F6D202A20746869732E696D6167652E6865696768740A092020202020207D3B0A0A092020202020207661722063616E766173203D2028302C205F6A7175657279325B2764656661756C74275D2928273C63616E766173202F3E';
wwv_flow_api.g_varchar2_table(219) := '27292E61747472287B0A09202020202020202077696474683A20746869732E7072657669657753697A652E7769647468202A206578706F72745A6F6F6D2C0A0920202020202020206865696768743A20746869732E7072657669657753697A652E686569';
wwv_flow_api.g_varchar2_table(220) := '676874202A206578706F72745A6F6F6D0A092020202020207D292E6765742830293B0A092020202020207661722063616E766173436F6E74657874203D2063616E7661732E676574436F6E746578742827326427293B0A0A092020202020206966202865';
wwv_flow_api.g_varchar2_table(221) := '78706F72744F7074696F6E732E74797065203D3D3D2027696D6167652F6A7065672729207B0A09202020202020202063616E766173436F6E746578742E66696C6C5374796C65203D206578706F72744F7074696F6E732E66696C6C42673B0A0920202020';
wwv_flow_api.g_varchar2_table(222) := '2020202063616E766173436F6E746578742E66696C6C5265637428302C20302C2063616E7661732E77696474682C2063616E7661732E686569676874293B0A092020202020207D0A0A0920202020202063616E766173436F6E746578742E7472616E736C';
wwv_flow_api.g_varchar2_table(223) := '61746528746869732E726F74617465644F66667365742E78202A206578706F72745A6F6F6D2C20746869732E726F74617465644F66667365742E79202A206578706F72745A6F6F6D293B0A0920202020202063616E766173436F6E746578742E726F7461';
wwv_flow_api.g_varchar2_table(224) := '746528746869732E726F746174696F6E202A204D6174682E5049202F20313830293B0A0920202020202063616E766173436F6E746578742E64726177496D61676528746869732E696D6167652C20302C20302C207A6F6F6D656453697A652E7769647468';
wwv_flow_api.g_varchar2_table(225) := '2C207A6F6F6D656453697A652E686569676874293B0A0A0920202020202072657475726E2063616E7661732E746F4461746155524C286578706F72744F7074696F6E732E747970652C206578706F72744F7074696F6E732E7175616C697479293B0A0920';
wwv_flow_api.g_varchar2_table(226) := '2020207D0A0920207D2C207B0A09202020206B65793A202764697361626C65272C0A092020202076616C75653A2066756E6374696F6E2064697361626C652829207B0A09202020202020746869732E756E62696E644C697374656E65727328293B0A0920';
wwv_flow_api.g_varchar2_table(227) := '2020202020746869732E64697361626C655A6F6F6D536C6964657228293B0A09202020202020746869732E24656C2E616464436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E44495341424C4544293B0A09202020207D0A092020';
wwv_flow_api.g_varchar2_table(228) := '7D2C207B0A09202020206B65793A20277265656E61626C65272C0A092020202076616C75653A2066756E6374696F6E207265656E61626C652829207B0A09202020202020746869732E62696E644C697374656E65727328293B0A09202020202020746869';
wwv_flow_api.g_varchar2_table(229) := '732E656E61626C655A6F6F6D536C6964657228293B0A09202020202020746869732E24656C2E72656D6F7665436C617373285F636F6E7374616E74732E434C4153535F4E414D45532E44495341424C4544293B0A09202020207D0A0920207D2C207B0A09';
wwv_flow_api.g_varchar2_table(230) := '202020206B65793A202724272C0A092020202076616C75653A2066756E6374696F6E20242873656C6563746F7229207B0A092020202020206966202821746869732E24656C29207B0A09202020202020202072657475726E206E756C6C3B0A0920202020';
wwv_flow_api.g_varchar2_table(231) := '20207D0A0920202020202072657475726E20746869732E24656C2E66696E642873656C6563746F72293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276F6666736574272C0A09202020207365743A2066756E6374696F6E2028706F';
wwv_flow_api.g_varchar2_table(232) := '736974696F6E29207B0A092020202020206966202821706F736974696F6E207C7C202128302C205F7574696C732E6578697374732928706F736974696F6E2E7829207C7C202128302C205F7574696C732E6578697374732928706F736974696F6E2E7929';
wwv_flow_api.g_varchar2_table(233) := '29207B0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020746869732E5F6F6666736574203D20746869732E6669784F666673657428706F736974696F6E293B0A09202020202020746869732E72656E646572496D61';
wwv_flow_api.g_varchar2_table(234) := '676528293B0A0A09202020202020746869732E6F7074696F6E732E6F6E4F66667365744368616E676528706F736974696F6E293B0A09202020207D2C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E2074';
wwv_flow_api.g_varchar2_table(235) := '6869732E5F6F66667365743B0A09202020207D0A0920207D2C207B0A09202020206B65793A20277A6F6F6D272C0A09202020207365743A2066756E6374696F6E20286E65775A6F6F6D29207B0A092020202020206E65775A6F6F6D203D20746869732E66';
wwv_flow_api.g_varchar2_table(236) := '69785A6F6F6D286E65775A6F6F6D293B0A0A0920202020202069662028746869732E696D6167654C6F6164656429207B0A092020202020202020766172206F6C645A6F6F6D203D20746869732E7A6F6F6D3B0A0A092020202020202020766172206E6577';
wwv_flow_api.g_varchar2_table(237) := '58203D20746869732E7072657669657753697A652E7769647468202F2032202D2028746869732E7072657669657753697A652E7769647468202F2032202D20746869732E6F66667365742E7829202A206E65775A6F6F6D202F206F6C645A6F6F6D3B0A09';
wwv_flow_api.g_varchar2_table(238) := '2020202020202020766172206E657759203D20746869732E7072657669657753697A652E686569676874202F2032202D2028746869732E7072657669657753697A652E686569676874202F2032202D20746869732E6F66667365742E7929202A206E6577';
wwv_flow_api.g_varchar2_table(239) := '5A6F6F6D202F206F6C645A6F6F6D3B0A0A092020202020202020746869732E5F7A6F6F6D203D206E65775A6F6F6D3B0A092020202020202020746869732E6F6666736574203D207B20783A206E6577582C20793A206E657759207D3B202F2F2054726967';
wwv_flow_api.g_varchar2_table(240) := '676572732072656E646572496D61676528290A092020202020207D20656C7365207B0A092020202020202020746869732E5F7A6F6F6D203D206E65775A6F6F6D3B0A092020202020207D0A0A09202020202020746869732E7A6F6F6D536C69646572506F';
wwv_flow_api.g_varchar2_table(241) := '73203D20746869732E7A6F6F6D65722E676574536C69646572506F7328746869732E7A6F6F6D293B0A09202020202020746869732E247A6F6F6D536C696465722E76616C28746869732E7A6F6F6D536C69646572506F73293B0A0A092020202020207468';
wwv_flow_api.g_varchar2_table(242) := '69732E6F7074696F6E732E6F6E5A6F6F6D4368616E6765286E65775A6F6F6D293B0A09202020207D2C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20746869732E5F7A6F6F6D3B0A09202020207D0A09';
wwv_flow_api.g_varchar2_table(243) := '20207D2C207B0A09202020206B65793A2027726F74617465644F6666736574272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E207B0A092020202020202020783A20746869732E6F66667365742E7820';
wwv_flow_api.g_varchar2_table(244) := '2B2028746869732E726F746174696F6E203D3D3D203930203F20746869732E696D6167652E686569676874202A20746869732E7A6F6F6D203A203029202B2028746869732E726F746174696F6E203D3D3D20313830203F20746869732E696D6167652E77';
wwv_flow_api.g_varchar2_table(245) := '69647468202A20746869732E7A6F6F6D203A2030292C0A092020202020202020793A20746869732E6F66667365742E79202B2028746869732E726F746174696F6E203D3D3D20313830203F20746869732E696D6167652E686569676874202A2074686973';
wwv_flow_api.g_varchar2_table(246) := '2E7A6F6F6D203A203029202B2028746869732E726F746174696F6E203D3D3D20323730203F20746869732E696D6167652E7769647468202A20746869732E7A6F6F6D203A2030290A092020202020207D3B0A09202020207D0A0920207D2C207B0A092020';
wwv_flow_api.g_varchar2_table(247) := '20206B65793A2027726F746174696F6E272C0A09202020207365743A2066756E6374696F6E20286E6577526F746174696F6E29207B0A09202020202020746869732E5F726F746174696F6E203D206E6577526F746174696F6E3B0A0A0920202020202069';
wwv_flow_api.g_varchar2_table(248) := '662028746869732E696D6167654C6F6164656429207B0A0920202020202020202F2F204368616E676520696E20696D6167652073697A65206D6179206C65616420746F206368616E676520696E207A6F6F6D2072616E67650A0920202020202020207468';
wwv_flow_api.g_varchar2_table(249) := '69732E73657475705A6F6F6D657228293B0A092020202020207D0A09202020207D2C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20746869732E5F726F746174696F6E3B0A09202020207D0A0920207D';
wwv_flow_api.g_varchar2_table(250) := '2C207B0A09202020206B65793A2027696D6167655374617465272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E207B0A0920202020202020207372633A20746869732E696D6167652E7372632C0A0920';
wwv_flow_api.g_varchar2_table(251) := '202020202020206F66667365743A20746869732E6F66667365742C0A0920202020202020207A6F6F6D3A20746869732E7A6F6F6D0A092020202020207D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027696D616765537263272C0A';
wwv_flow_api.g_varchar2_table(252) := '09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20746869732E696D6167652E7372633B0A09202020207D2C0A09202020207365743A2066756E6374696F6E2028696D61676553726329207B0A092020202020';
wwv_flow_api.g_varchar2_table(253) := '20746869732E6C6F6164496D61676528696D616765537263293B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027696D6167655769647468272C0A09202020206765743A2066756E6374696F6E202829207B0A09202020202020726574';
wwv_flow_api.g_varchar2_table(254) := '75726E20746869732E726F746174696F6E202520313830203D3D3D2030203F20746869732E696D6167652E7769647468203A20746869732E696D6167652E6865696768743B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027696D6167';
wwv_flow_api.g_varchar2_table(255) := '65486569676874272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20746869732E726F746174696F6E202520313830203D3D3D2030203F20746869732E696D6167652E686569676874203A2074686973';
wwv_flow_api.g_varchar2_table(256) := '2E696D6167652E77696474683B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027696D61676553697A65272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E207B0A0920202020202020';
wwv_flow_api.g_varchar2_table(257) := '2077696474683A20746869732E696D61676557696474682C0A0920202020202020206865696768743A20746869732E696D6167654865696768740A092020202020207D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027696E697469';
wwv_flow_api.g_varchar2_table(258) := '616C5A6F6F6D272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20746869732E6F7074696F6E732E696E697469616C5A6F6F6D3B0A09202020207D2C0A09202020207365743A2066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(259) := '28696E697469616C5A6F6F6D4F7074696F6E29207B0A09202020202020746869732E6F7074696F6E732E696E697469616C5A6F6F6D203D20696E697469616C5A6F6F6D4F7074696F6E3B0A0920202020202069662028696E697469616C5A6F6F6D4F7074';
wwv_flow_api.g_varchar2_table(260) := '696F6E203D3D3D20276D696E2729207B0A092020202020202020746869732E5F696E697469616C5A6F6F6D203D20303B202F2F2057696C6C206265206669786564207768656E20696D616765206C6F6164730A092020202020207D20656C736520696620';
wwv_flow_api.g_varchar2_table(261) := '28696E697469616C5A6F6F6D4F7074696F6E203D3D3D2027696D6167652729207B0A092020202020202020746869732E5F696E697469616C5A6F6F6D203D20313B0A092020202020207D20656C7365207B0A092020202020202020746869732E5F696E69';
wwv_flow_api.g_varchar2_table(262) := '7469616C5A6F6F6D203D20303B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A20276578706F72745A6F6F6D272C0A09202020206765743A2066756E6374696F6E202829207B0A0920202020202072657475726E20';
wwv_flow_api.g_varchar2_table(263) := '746869732E6F7074696F6E732E6578706F72745A6F6F6D3B0A09202020207D2C0A09202020207365743A2066756E6374696F6E20286578706F72745A6F6F6D29207B0A09202020202020746869732E6F7074696F6E732E6578706F72745A6F6F6D203D20';
wwv_flow_api.g_varchar2_table(264) := '6578706F72745A6F6F6D3B0A09202020202020746869732E73657475705A6F6F6D657228293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276D696E5A6F6F6D272C0A09202020206765743A2066756E6374696F6E202829207B0A09';
wwv_flow_api.g_varchar2_table(265) := '20202020202072657475726E20746869732E6F7074696F6E732E6D696E5A6F6F6D3B0A09202020207D2C0A09202020207365743A2066756E6374696F6E20286D696E5A6F6F6D29207B0A09202020202020746869732E6F7074696F6E732E6D696E5A6F6F';
wwv_flow_api.g_varchar2_table(266) := '6D203D206D696E5A6F6F6D3B0A09202020202020746869732E73657475705A6F6F6D657228293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276D61785A6F6F6D272C0A09202020206765743A2066756E6374696F6E202829207B0A';
wwv_flow_api.g_varchar2_table(267) := '0920202020202072657475726E20746869732E6F7074696F6E732E6D61785A6F6F6D3B0A09202020207D2C0A09202020207365743A2066756E6374696F6E20286D61785A6F6F6D29207B0A09202020202020746869732E6F7074696F6E732E6D61785A6F';
wwv_flow_api.g_varchar2_table(268) := '6F6D203D206D61785A6F6F6D3B0A09202020202020746869732E73657475705A6F6F6D657228293B0A09202020207D0A0920207D2C207B0A09202020206B65793A20277072657669657753697A65272C0A09202020206765743A2066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(269) := '2829207B0A0920202020202072657475726E20746869732E5F7072657669657753697A653B0A09202020207D2C0A09202020207365743A2066756E6374696F6E202873697A6529207B0A09202020202020696620282173697A65207C7C2073697A652E77';
wwv_flow_api.g_varchar2_table(270) := '69647468203C3D2030207C7C2073697A652E686569676874203C3D203029207B0A09202020202020202072657475726E3B0A092020202020207D0A0A09202020202020746869732E5F7072657669657753697A65203D207B0A0920202020202020207769';
wwv_flow_api.g_varchar2_table(271) := '6474683A2073697A652E77696474682C0A0920202020202020206865696768743A2073697A652E6865696768740A092020202020207D3B0A09202020202020746869732E24707265766965772E696E6E6572576964746828746869732E70726576696577';
wwv_flow_api.g_varchar2_table(272) := '53697A652E7769647468292E696E6E657248656967687428746869732E7072657669657753697A652E686569676874293B0A0A0920202020202069662028746869732E696D6167654C6F6164656429207B0A092020202020202020746869732E73657475';
wwv_flow_api.g_varchar2_table(273) := '705A6F6F6D657228293B0A092020202020207D0A09202020207D0A0920207D5D293B0A0A09202072657475726E2043726F7069743B0A097D2928293B0A0A096578706F7274735B2764656661756C74275D203D2043726F7069743B0A096D6F64756C652E';
wwv_flow_api.g_varchar2_table(274) := '6578706F727473203D206578706F7274735B2764656661756C74275D3B0A0A2F2A2A2A2F207D2C0A2F2A2033202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F72747329207B0A0A094F626A6563742E646566696E6550726F';
wwv_flow_api.g_varchar2_table(275) := '7065727479286578706F7274732C20275F5F65734D6F64756C65272C207B0A09202076616C75653A20747275650A097D293B0A0A09766172205F637265617465436C617373203D202866756E6374696F6E202829207B2066756E6374696F6E2064656669';
wwv_flow_api.g_varchar2_table(276) := '6E6550726F70657274696573287461726765742C2070726F707329207B20666F7220287661722069203D20303B2069203C2070726F70732E6C656E6774683B20692B2B29207B207661722064657363726970746F72203D2070726F70735B695D3B206465';
wwv_flow_api.g_varchar2_table(277) := '7363726970746F722E656E756D657261626C65203D2064657363726970746F722E656E756D657261626C65207C7C2066616C73653B2064657363726970746F722E636F6E666967757261626C65203D20747275653B20696620282776616C75652720696E';
wwv_flow_api.g_varchar2_table(278) := '2064657363726970746F72292064657363726970746F722E7772697461626C65203D20747275653B204F626A6563742E646566696E6550726F7065727479287461726765742C2064657363726970746F722E6B65792C2064657363726970746F72293B20';
wwv_flow_api.g_varchar2_table(279) := '7D207D2072657475726E2066756E6374696F6E2028436F6E7374727563746F722C2070726F746F50726F70732C2073746174696350726F707329207B206966202870726F746F50726F70732920646566696E6550726F7065727469657328436F6E737472';
wwv_flow_api.g_varchar2_table(280) := '7563746F722E70726F746F747970652C2070726F746F50726F7073293B206966202873746174696350726F70732920646566696E6550726F7065727469657328436F6E7374727563746F722C2073746174696350726F7073293B2072657475726E20436F';
wwv_flow_api.g_varchar2_table(281) := '6E7374727563746F723B207D3B207D2928293B0A0A0966756E6374696F6E205F636C61737343616C6C436865636B28696E7374616E63652C20436F6E7374727563746F7229207B20696620282128696E7374616E636520696E7374616E63656F6620436F';
wwv_flow_api.g_varchar2_table(282) := '6E7374727563746F722929207B207468726F77206E657720547970654572726F72282743616E6E6F742063616C6C206120636C61737320617320612066756E6374696F6E27293B207D207D0A0A09766172205A6F6F6D6572203D202866756E6374696F6E';
wwv_flow_api.g_varchar2_table(283) := '202829207B0A09202066756E6374696F6E205A6F6F6D65722829207B0A09202020205F636C61737343616C6C436865636B28746869732C205A6F6F6D6572293B0A0A0920202020746869732E6D696E5A6F6F6D203D20746869732E6D61785A6F6F6D203D';
wwv_flow_api.g_varchar2_table(284) := '20313B0A0920207D0A0A0920205F637265617465436C617373285A6F6F6D65722C205B7B0A09202020206B65793A20277365747570272C0A092020202076616C75653A2066756E6374696F6E207365747570285F72656629207B0A092020202020207661';
wwv_flow_api.g_varchar2_table(285) := '7220696D61676553697A65203D205F7265662E696D61676553697A653B0A09202020202020766172207072657669657753697A65203D205F7265662E7072657669657753697A653B0A09202020202020766172206578706F72745A6F6F6D203D205F7265';
wwv_flow_api.g_varchar2_table(286) := '662E6578706F72745A6F6F6D3B0A09202020202020766172206D61785A6F6F6D203D205F7265662E6D61785A6F6F6D3B0A09202020202020766172206D696E5A6F6F6D203D205F7265662E6D696E5A6F6F6D3B0A0920202020202076617220736D616C6C';
wwv_flow_api.g_varchar2_table(287) := '496D616765203D205F7265662E736D616C6C496D6167653B0A0A09202020202020766172207769647468526174696F203D207072657669657753697A652E7769647468202F20696D61676553697A652E77696474683B0A09202020202020766172206865';
wwv_flow_api.g_varchar2_table(288) := '69676874526174696F203D207072657669657753697A652E686569676874202F20696D61676553697A652E6865696768743B0A0A09202020202020696620286D696E5A6F6F6D203D3D3D20276669742729207B0A092020202020202020746869732E6D69';
wwv_flow_api.g_varchar2_table(289) := '6E5A6F6F6D203D204D6174682E6D696E287769647468526174696F2C20686569676874526174696F293B0A092020202020207D20656C7365207B0A092020202020202020746869732E6D696E5A6F6F6D203D204D6174682E6D6178287769647468526174';
wwv_flow_api.g_varchar2_table(290) := '696F2C20686569676874526174696F293B0A092020202020207D0A0A0920202020202069662028736D616C6C496D616765203D3D3D2027616C6C6F772729207B0A092020202020202020746869732E6D696E5A6F6F6D203D204D6174682E6D696E287468';
wwv_flow_api.g_varchar2_table(291) := '69732E6D696E5A6F6F6D2C2031293B0A092020202020207D0A0A09202020202020746869732E6D61785A6F6F6D203D204D6174682E6D617828746869732E6D696E5A6F6F6D2C206D61785A6F6F6D202F206578706F72745A6F6F6D293B0A09202020207D';
wwv_flow_api.g_varchar2_table(292) := '0A0920207D2C207B0A09202020206B65793A20276765745A6F6F6D272C0A092020202076616C75653A2066756E6374696F6E206765745A6F6F6D28736C69646572506F7329207B0A092020202020206966202821746869732E6D696E5A6F6F6D207C7C20';
wwv_flow_api.g_varchar2_table(293) := '21746869732E6D61785A6F6F6D29207B0A09202020202020202072657475726E206E756C6C3B0A092020202020207D0A0A0920202020202072657475726E20736C69646572506F73202A2028746869732E6D61785A6F6F6D202D20746869732E6D696E5A';
wwv_flow_api.g_varchar2_table(294) := '6F6F6D29202B20746869732E6D696E5A6F6F6D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A2027676574536C69646572506F73272C0A092020202076616C75653A2066756E6374696F6E20676574536C69646572506F73287A6F6F6D';
wwv_flow_api.g_varchar2_table(295) := '29207B0A092020202020206966202821746869732E6D696E5A6F6F6D207C7C2021746869732E6D61785A6F6F6D29207B0A09202020202020202072657475726E206E756C6C3B0A092020202020207D0A0A0920202020202069662028746869732E6D696E';
wwv_flow_api.g_varchar2_table(296) := '5A6F6F6D203D3D3D20746869732E6D61785A6F6F6D29207B0A09202020202020202072657475726E20303B0A092020202020207D20656C7365207B0A09202020202020202072657475726E20287A6F6F6D202D20746869732E6D696E5A6F6F6D29202F20';
wwv_flow_api.g_varchar2_table(297) := '28746869732E6D61785A6F6F6D202D20746869732E6D696E5A6F6F6D293B0A092020202020207D0A09202020207D0A0920207D2C207B0A09202020206B65793A202769735A6F6F6D61626C65272C0A092020202076616C75653A2066756E6374696F6E20';
wwv_flow_api.g_varchar2_table(298) := '69735A6F6F6D61626C652829207B0A092020202020206966202821746869732E6D696E5A6F6F6D207C7C2021746869732E6D61785A6F6F6D29207B0A09202020202020202072657475726E206E756C6C3B0A092020202020207D0A0A0920202020202072';
wwv_flow_api.g_varchar2_table(299) := '657475726E20746869732E6D696E5A6F6F6D20213D3D20746869732E6D61785A6F6F6D3B0A09202020207D0A0920207D2C207B0A09202020206B65793A20276669785A6F6F6D272C0A092020202076616C75653A2066756E6374696F6E206669785A6F6F';
wwv_flow_api.g_varchar2_table(300) := '6D287A6F6F6D29207B0A0920202020202072657475726E204D6174682E6D617828746869732E6D696E5A6F6F6D2C204D6174682E6D696E28746869732E6D61785A6F6F6D2C207A6F6F6D29293B0A09202020207D0A0920207D5D293B0A0A092020726574';
wwv_flow_api.g_varchar2_table(301) := '75726E205A6F6F6D65723B0A097D2928293B0A0A096578706F7274735B2764656661756C74275D203D205A6F6F6D65723B0A096D6F64756C652E6578706F727473203D206578706F7274735B2764656661756C74275D3B0A0A2F2A2A2A2F207D2C0A2F2A';
wwv_flow_api.g_varchar2_table(302) := '2034202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F72747329207B0A0A094F626A6563742E646566696E6550726F7065727479286578706F7274732C20275F5F65734D6F64756C65272C207B0A09202076616C75653A2074';
wwv_flow_api.g_varchar2_table(303) := '7275650A097D293B0A0976617220504C5547494E5F4B4559203D202763726F706974273B0A0A096578706F7274732E504C5547494E5F4B4559203D20504C5547494E5F4B45593B0A0976617220434C4153535F4E414D4553203D207B0A09202050524556';
wwv_flow_api.g_varchar2_table(304) := '4945573A202763726F7069742D70726576696577272C0A092020505245564945575F494D4147455F434F4E5441494E45523A202763726F7069742D707265766965772D696D6167652D636F6E7461696E6572272C0A092020505245564945575F494D4147';
wwv_flow_api.g_varchar2_table(305) := '453A202763726F7069742D707265766965772D696D616765272C0A092020505245564945575F4241434B47524F554E445F434F4E5441494E45523A202763726F7069742D707265766965772D6261636B67726F756E642D636F6E7461696E6572272C0A09';
wwv_flow_api.g_varchar2_table(306) := '2020505245564945575F4241434B47524F554E443A202763726F7069742D707265766965772D6261636B67726F756E64272C0A09202046494C455F494E5055543A202763726F7069742D696D6167652D696E707574272C0A0920205A4F4F4D5F534C4944';
wwv_flow_api.g_varchar2_table(307) := '45523A202763726F7069742D696D6167652D7A6F6F6D2D696E707574272C0A0A092020445241475F484F56455245443A202763726F7069742D647261672D686F7665726564272C0A092020494D4147455F4C4F4144494E473A202763726F7069742D696D';
wwv_flow_api.g_varchar2_table(308) := '6167652D6C6F6164696E67272C0A092020494D4147455F4C4F414445443A202763726F7069742D696D6167652D6C6F61646564272C0A09202044495341424C45443A202763726F7069742D64697361626C6564270A097D3B0A0A096578706F7274732E43';
wwv_flow_api.g_varchar2_table(309) := '4C4153535F4E414D4553203D20434C4153535F4E414D45533B0A09766172204552524F5253203D207B0A092020494D4147455F4641494C45445F544F5F4C4F41443A207B20636F64653A20302C206D6573736167653A2027496D616765206661696C6564';
wwv_flow_api.g_varchar2_table(310) := '20746F206C6F61642E27207D2C0A092020534D414C4C5F494D4147453A207B20636F64653A20312C206D6573736167653A2027496D61676520697320746F6F20736D616C6C2E27207D0A097D3B0A0A096578706F7274732E4552524F5253203D20455252';
wwv_flow_api.g_varchar2_table(311) := '4F52533B0A09766172206576656E744E616D65203D2066756E6374696F6E206576656E744E616D65286576656E747329207B0A09202072657475726E206576656E74732E6D61702866756E6374696F6E20286529207B0A092020202072657475726E2027';
wwv_flow_api.g_varchar2_table(312) := '27202B2065202B20272E63726F706974273B0A0920207D292E6A6F696E28272027293B0A097D3B0A09766172204556454E5453203D207B0A092020505245564945573A206576656E744E616D65285B276D6F757365646F776E272C20276D6F7573657570';
wwv_flow_api.g_varchar2_table(313) := '272C20276D6F7573656C65617665272C2027746F7563687374617274272C2027746F756368656E64272C2027746F75636863616E63656C272C2027746F7563686C65617665275D292C0A092020505245564945575F4D4F56453A206576656E744E616D65';
wwv_flow_api.g_varchar2_table(314) := '285B276D6F7573656D6F7665272C2027746F7563686D6F7665275D292C0A0920205A4F4F4D5F494E5055543A206576656E744E616D65285B276D6F7573656D6F7665272C2027746F7563686D6F7665272C20276368616E6765275D290A097D3B0A096578';
wwv_flow_api.g_varchar2_table(315) := '706F7274732E4556454E5453203D204556454E54533B0A0A2F2A2A2A2F207D2C0A2F2A2035202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64756C652C206578706F7274732C205F5F7765627061636B5F726571756972655F5F29207B0A0A094F62';
wwv_flow_api.g_varchar2_table(316) := '6A6563742E646566696E6550726F7065727479286578706F7274732C20275F5F65734D6F64756C65272C207B0A09202076616C75653A20747275650A097D293B0A0A09766172205F636F6E7374616E7473203D205F5F7765627061636B5F726571756972';
wwv_flow_api.g_varchar2_table(317) := '655F5F2834293B0A0A09766172206F7074696F6E73203D207B0A092020656C656D656E74733A205B7B0A09202020206E616D653A20272470726576696577272C0A09202020206465736372697074696F6E3A20275468652048544D4C20656C656D656E74';
wwv_flow_api.g_varchar2_table(318) := '207468617420646973706C61797320696D61676520707265766965772E272C0A092020202064656661756C7453656C6563746F723A20272E27202B205F636F6E7374616E74732E434C4153535F4E414D45532E505245564945570A0920207D2C207B0A09';
wwv_flow_api.g_varchar2_table(319) := '202020206E616D653A20272466696C65496E707574272C0A09202020206465736372697074696F6E3A202746696C6520696E70757420656C656D656E742E272C0A092020202064656661756C7453656C6563746F723A2027696E7075742E27202B205F63';
wwv_flow_api.g_varchar2_table(320) := '6F6E7374616E74732E434C4153535F4E414D45532E46494C455F494E5055540A0920207D2C207B0A09202020206E616D653A2027247A6F6F6D536C69646572272C0A09202020206465736372697074696F6E3A202752616E676520696E70757420656C65';
wwv_flow_api.g_varchar2_table(321) := '6D656E74207468617420636F6E74726F6C7320696D616765207A6F6F6D2E272C0A092020202064656661756C7453656C6563746F723A2027696E7075742E27202B205F636F6E7374616E74732E434C4153535F4E414D45532E5A4F4F4D5F534C49444552';
wwv_flow_api.g_varchar2_table(322) := '0A0920207D5D2E6D61702866756E6374696F6E20286F29207B0A09202020206F2E74797065203D20276A517565727920656C656D656E74273B0A09202020206F5B2764656661756C74275D203D202724696D61676543726F707065722E66696E64285C27';
wwv_flow_api.g_varchar2_table(323) := '27202B206F2E64656661756C7453656C6563746F72202B20275C2729273B0A092020202072657475726E206F3B0A0920207D292C0A0A09202076616C7565733A205B7B0A09202020206E616D653A20277769647468272C0A0920202020747970653A2027';
wwv_flow_api.g_varchar2_table(324) := '6E756D626572272C0A09202020206465736372697074696F6E3A20275769647468206F6620696D616765207072657669657720696E20706978656C732E204966207365742C2069742077696C6C206F7665727269646520746865204353532070726F7065';
wwv_flow_api.g_varchar2_table(325) := '7274792E272C0A09202020202764656661756C74273A206E756C6C0A0920207D2C207B0A09202020206E616D653A2027686569676874272C0A0920202020747970653A20276E756D626572272C0A09202020206465736372697074696F6E3A2027486569';
wwv_flow_api.g_varchar2_table(326) := '676874206F6620696D616765207072657669657720696E20706978656C732E204966207365742C2069742077696C6C206F7665727269646520746865204353532070726F70657274792E272C0A09202020202764656661756C74273A206E756C6C0A0920';
wwv_flow_api.g_varchar2_table(327) := '207D2C207B0A09202020206E616D653A2027696D6167654261636B67726F756E64272C0A0920202020747970653A2027626F6F6C65616E272C0A09202020206465736372697074696F6E3A202757686574686572206F72206E6F7420746F20646973706C';
wwv_flow_api.g_varchar2_table(328) := '617920746865206261636B67726F756E6420696D616765206265796F6E6420746865207072657669657720617265612E272C0A09202020202764656661756C74273A2066616C73650A0920207D2C207B0A09202020206E616D653A2027696D6167654261';
wwv_flow_api.g_varchar2_table(329) := '636B67726F756E64426F726465725769647468272C0A0920202020747970653A20276172726179206F72206E756D626572272C0A09202020206465736372697074696F6E3A20275769647468206F66206261636B67726F756E6420696D61676520626F72';
wwv_flow_api.g_varchar2_table(330) := '64657220696E20706978656C732E5C6E202020202020202054686520666F757220617272617920656C656D656E7473207370656369667920746865207769647468206F66206261636B67726F756E6420696D616765207769647468206F6E207468652074';
wwv_flow_api.g_varchar2_table(331) := '6F702C2072696768742C20626F74746F6D2C206C656674207369646520726573706563746976656C792E5C6E2020202020202020546865206261636B67726F756E6420696D616765206265796F6E64207468652077696474682077696C6C206265206869';
wwv_flow_api.g_varchar2_table(332) := '6464656E2E5C6E20202020202020204966207370656369666965642061732061206E756D6265722C20626F72646572207769746820756E69666F726D207769647468206F6E20616C6C2073696465732077696C6C206265206170706C6965642E272C0A09';
wwv_flow_api.g_varchar2_table(333) := '202020202764656661756C74273A205B302C20302C20302C20305D0A0920207D2C207B0A09202020206E616D653A20276578706F72745A6F6F6D272C0A0920202020747970653A20276E756D626572272C0A09202020206465736372697074696F6E3A20';
wwv_flow_api.g_varchar2_table(334) := '2754686520726174696F206265747765656E20746865206465736972656420696D6167652073697A6520746F206578706F727420616E642074686520707265766965772073697A652E5C6E2020202020202020466F72206578616D706C652C2069662074';
wwv_flow_api.g_varchar2_table(335) := '686520707265766965772073697A6520697320603330307078202A203230307078602C20616E6420606578706F72745A6F6F6D203D2032602C207468656E5C6E2020202020202020746865206578706F7274656420696D6167652073697A652077696C6C';
wwv_flow_api.g_varchar2_table(336) := '20626520603630307078202A203430307078602E5C6E20202020202020205468697320616C736F206166666563747320746865206D6178696D756D207A6F6F6D206C6576656C2C2073696E636520746865206578706F7274656420696D6167652063616E';
wwv_flow_api.g_varchar2_table(337) := '6E6F74206265207A6F6F6D656420746F206C6172676572207468616E20697473206F726967696E616C2073697A652E272C0A09202020202764656661756C74273A20310A0920207D2C207B0A09202020206E616D653A2027616C6C6F77447261674E4472';
wwv_flow_api.g_varchar2_table(338) := '6F70272C0A0920202020747970653A2027626F6F6C65616E272C0A09202020206465736372697074696F6E3A20275768656E2073657420746F20747275652C20796F752063616E206C6F616420616E20696D616765206279206472616767696E67206974';
wwv_flow_api.g_varchar2_table(339) := '2066726F6D206C6F63616C2066696C652062726F77736572206F6E746F20746865207072657669657720617265612E272C0A09202020202764656661756C74273A20747275650A0920207D2C207B0A09202020206E616D653A20276D696E5A6F6F6D272C';
wwv_flow_api.g_varchar2_table(340) := '0A0920202020747970653A2027737472696E67272C0A09202020206465736372697074696F6E3A202754686973206F7074696F6E73206465636964657320746865206D696E696D616C207A6F6F6D206C6576656C206F662074686520696D6167652E5C6E';
wwv_flow_api.g_varchar2_table(341) := '202020202020202049662073657420746F20605C2766696C6C5C27602C2074686520696D6167652068617320746F2066696C6C20746865207072657669657720617265612C20692E652E20626F746820776964746820616E6420686569676874206D7573';
wwv_flow_api.g_varchar2_table(342) := '74206E6F7420676F20736D616C6C6572207468616E20746865207072657669657720617265612E5C6E202020202020202049662073657420746F20605C276669745C27602C2074686520696D6167652063616E20736872696E6B20667572746865722074';
wwv_flow_api.g_varchar2_table(343) := '6F2066697420746865207072657669657720617265612C20692E652E206174206C65617374206F6E65206F6620697473206564676573206D757374206E6F7420676F20736D616C6C6572207468616E20746865207072657669657720617265612E272C0A';
wwv_flow_api.g_varchar2_table(344) := '09202020202764656661756C74273A202766696C6C270A0920207D2C207B0A09202020206E616D653A20276D61785A6F6F6D272C0A0920202020747970653A20276E756D626572272C0A09202020206465736372697074696F6E3A202744657465726D69';
wwv_flow_api.g_varchar2_table(345) := '6E657320686F77206269672074686520696D6167652063616E206265207A6F6F6D65642E20452E672E2069662073657420746F20312E352C2074686520696D6167652063616E206265207A6F6F6D656420746F2031353025206F6620697473206F726967';
wwv_flow_api.g_varchar2_table(346) := '696E616C2073697A652E272C0A09202020202764656661756C74273A20310A0920207D2C207B0A09202020206E616D653A2027696E697469616C5A6F6F6D272C0A0920202020747970653A2027737472696E67272C0A0920202020646573637269707469';
wwv_flow_api.g_varchar2_table(347) := '6F6E3A202744657465726D696E657320746865207A6F6F6D207768656E20616E20696D616765206973206C6F616465642E5C6E20202020202020205768656E2073657420746F20605C276D696E5C27602C20696D616765206973207A6F6F6D656420746F';
wwv_flow_api.g_varchar2_table(348) := '2074686520736D616C6C657374207768656E206C6F616465642E5C6E20202020202020205768656E2073657420746F20605C27696D6167655C27602C20696D616765206973207A6F6F6D656420746F2031303025207768656E206C6F616465642E272C0A';
wwv_flow_api.g_varchar2_table(349) := '09202020202764656661756C74273A20276D696E270A0920207D2C207B0A09202020206E616D653A2027667265654D6F7665272C0A0920202020747970653A2027626F6F6C65616E272C0A09202020206465736372697074696F6E3A20275768656E2073';
wwv_flow_api.g_varchar2_table(350) := '657420746F20747275652C20796F752063616E20667265656C79206D6F76652074686520696D61676520696E7374656164206F66206265696E6720626F756E6420746F2074686520636F6E7461696E657220626F7264657273272C0A0920202020276465';
wwv_flow_api.g_varchar2_table(351) := '6661756C74273A2066616C73650A0920207D2C207B0A09202020206E616D653A2027736D616C6C496D616765272C0A0920202020747970653A2027737472696E67272C0A09202020206465736372697074696F6E3A20275768656E2073657420746F2060';
wwv_flow_api.g_varchar2_table(352) := '5C2772656A6563745C27602C20606F6E496D6167654572726F726020776F756C642062652063616C6C6564207768656E2063726F706974206C6F61647320616E20696D616765207468617420697320736D616C6C6572207468616E2074686520636F6E74';
wwv_flow_api.g_varchar2_table(353) := '61696E65722E5C6E20202020202020205768656E2073657420746F20605C27616C6C6F775C27602C20696D6167657320736D616C6C6572207468616E2074686520636F6E7461696E65722063616E206265207A6F6F6D656420646F776E20746F20697473';
wwv_flow_api.g_varchar2_table(354) := '206F726967696E616C2073697A652C206F7665726964696E6720606D696E5A6F6F6D60206F7074696F6E2E5C6E20202020202020205768656E2073657420746F20605C27737472657463685C27602C20746865206D696E696D756D207A6F6F6D206F6620';
wwv_flow_api.g_varchar2_table(355) := '736D616C6C20696D6167657320776F756C6420666F6C6C6F7720606D696E5A6F6F6D60206F7074696F6E2E272C0A09202020202764656661756C74273A202772656A656374270A0920207D5D2C0A0A09202063616C6C6261636B733A205B7B0A09202020';
wwv_flow_api.g_varchar2_table(356) := '206E616D653A20276F6E46696C654368616E6765272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E20757365722073656C6563747320612066696C6520696E207468652073656C6563742066696C6520696E7075742E27';
wwv_flow_api.g_varchar2_table(357) := '2C0A0920202020706172616D733A205B7B0A092020202020206E616D653A20276576656E74272C0A09202020202020747970653A20276F626A656374272C0A092020202020206465736372697074696F6E3A202746696C65206368616E6765206576656E';
wwv_flow_api.g_varchar2_table(358) := '74206F626A656374270A09202020207D5D0A0920207D2C207B0A09202020206E616D653A20276F6E46696C655265616465724572726F72272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E206046696C65526561646572';
wwv_flow_api.g_varchar2_table(359) := '6020656E636F756E7465727320616E206572726F72207768696C65206C6F6164696E672074686520696D6167652066696C652E270A0920207D2C207B0A09202020206E616D653A20276F6E496D6167654C6F6164696E67272C0A09202020206465736372';
wwv_flow_api.g_varchar2_table(360) := '697074696F6E3A202743616C6C6564207768656E20696D6167652073746172747320746F206265206C6F616465642E270A0920207D2C207B0A09202020206E616D653A20276F6E496D6167654C6F61646564272C0A09202020206465736372697074696F';
wwv_flow_api.g_varchar2_table(361) := '6E3A202743616C6C6564207768656E20696D616765206973206C6F616465642E270A0920207D2C207B0A09202020206E616D653A20276F6E496D6167654572726F72272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E20';
wwv_flow_api.g_varchar2_table(362) := '696D6167652063616E6E6F74206265206C6F616465642E272C0A0920202020706172616D733A205B7B0A092020202020206E616D653A20276572726F72272C0A09202020202020747970653A20276F626A656374272C0A09202020202020646573637269';
wwv_flow_api.g_varchar2_table(363) := '7074696F6E3A20274572726F72206F626A6563742E270A09202020207D2C207B0A092020202020206E616D653A20276572726F722E636F6465272C0A09202020202020747970653A20276E756D626572272C0A092020202020206465736372697074696F';
wwv_flow_api.g_varchar2_table(364) := '6E3A20274572726F7220636F64652E20603060206D65616E732067656E6572696320696D616765206C6F6164696E67206661696C7572652E20603160206D65616E7320696D61676520697320746F6F20736D616C6C2E270A09202020207D2C207B0A0920';
wwv_flow_api.g_varchar2_table(365) := '20202020206E616D653A20276572726F722E6D657373616765272C0A09202020202020747970653A2027737472696E67272C0A092020202020206465736372697074696F6E3A202741206D657373616765206578706C61696E696E672074686520657272';
wwv_flow_api.g_varchar2_table(366) := '6F722E270A09202020207D5D0A0920207D2C207B0A09202020206E616D653A20276F6E5A6F6F6D456E61626C6564272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E20696D61676520746865207A6F6F6D20736C696465';
wwv_flow_api.g_varchar2_table(367) := '7220697320656E61626C65642E270A0920207D2C207B0A09202020206E616D653A20276F6E5A6F6F6D44697361626C6564272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E20696D61676520746865207A6F6F6D20736C';
wwv_flow_api.g_varchar2_table(368) := '696465722069732064697361626C65642E270A0920207D2C207B0A09202020206E616D653A20276F6E5A6F6F6D4368616E6765272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E207A6F6F6D206368616E6765732E272C';
wwv_flow_api.g_varchar2_table(369) := '0A0920202020706172616D733A205B7B0A092020202020206E616D653A20277A6F6F6D272C0A09202020202020747970653A20276E756D626572272C0A092020202020206465736372697074696F6E3A20274E6577207A6F6F6D2E270A09202020207D5D';
wwv_flow_api.g_varchar2_table(370) := '0A0920207D2C207B0A09202020206E616D653A20276F6E4F66667365744368616E6765272C0A09202020206465736372697074696F6E3A202743616C6C6564207768656E20696D616765206F6666736574206368616E6765732E272C0A09202020207061';
wwv_flow_api.g_varchar2_table(371) := '72616D733A205B7B0A092020202020206E616D653A20276F6666736574272C0A09202020202020747970653A20276F626A656374272C0A092020202020206465736372697074696F6E3A20274E6577206F66667365742C20776974682060786020616E64';
wwv_flow_api.g_varchar2_table(372) := '206079602076616C7565732E270A09202020207D5D0A0920207D5D2E6D61702866756E6374696F6E20286F29207B0A09202020206F2E74797065203D202766756E6374696F6E273B72657475726E206F3B0A0920207D290A097D3B0A0A09766172206C6F';
wwv_flow_api.g_varchar2_table(373) := '616444656661756C7473203D2066756E6374696F6E206C6F616444656661756C74732824656C29207B0A0920207661722064656661756C7473203D207B7D3B0A0920206966202824656C29207B0A09202020206F7074696F6E732E656C656D656E74732E';
wwv_flow_api.g_varchar2_table(374) := '666F72456163682866756E6374696F6E20286F29207B0A0920202020202064656661756C74735B6F2E6E616D655D203D2024656C2E66696E64286F2E64656661756C7453656C6563746F72293B0A09202020207D293B0A0920207D0A0920206F7074696F';
wwv_flow_api.g_varchar2_table(375) := '6E732E76616C7565732E666F72456163682866756E6374696F6E20286F29207B0A092020202064656661756C74735B6F2E6E616D655D203D206F5B2764656661756C74275D3B0A0920207D293B0A0920206F7074696F6E732E63616C6C6261636B732E66';
wwv_flow_api.g_varchar2_table(376) := '6F72456163682866756E6374696F6E20286F29207B0A092020202064656661756C74735B6F2E6E616D655D203D2066756E6374696F6E202829207B7D3B0A0920207D293B0A0A09202072657475726E2064656661756C74733B0A097D3B0A0A096578706F';
wwv_flow_api.g_varchar2_table(377) := '7274732E6C6F616444656661756C7473203D206C6F616444656661756C74733B0A096578706F7274735B2764656661756C74275D203D206F7074696F6E733B0A0A2F2A2A2A2F207D2C0A2F2A2036202A2F0A2F2A2A2A2F2066756E6374696F6E286D6F64';
wwv_flow_api.g_varchar2_table(378) := '756C652C206578706F72747329207B0A0A094F626A6563742E646566696E6550726F7065727479286578706F7274732C20275F5F65734D6F64756C65272C207B0A09202076616C75653A20747275650A097D293B0A0976617220657869737473203D2066';
wwv_flow_api.g_varchar2_table(379) := '756E6374696F6E20657869737473287629207B0A09202072657475726E20747970656F66207620213D3D2027756E646566696E6564273B0A097D3B0A0A096578706F7274732E657869737473203D206578697374733B0A0976617220726F756E64203D20';
wwv_flow_api.g_varchar2_table(380) := '66756E6374696F6E20726F756E64287829207B0A09202072657475726E202B284D6174682E726F756E642878202A2031303029202B2027652D3227293B0A097D3B0A096578706F7274732E726F756E64203D20726F756E643B0A0A2F2A2A2A2F207D0A2F';
wwv_flow_api.g_varchar2_table(381) := '2A2A2A2A2A2A2F205D290A7D293B0A3B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(58966411226094502)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_file_name=>'jquery.cropit.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E63726F7069742D70726576696577207B0A20206261636B67726F756E642D636F6C6F723A20236638663866383B0A20206261636B67726F756E642D73697A653A20636F7665723B0A2020626F726465723A2031707820736F6C696420236363633B0A20';
wwv_flow_api.g_varchar2_table(2) := '20626F726465722D7261646975733A203370783B0A20206D617267696E2D746F703A203770783B0A202077696474683A2032353070783B0A20206865696768743A2032353070783B0A7D0A0A2E63726F7069742D707265766965772D696D6167652D636F';
wwv_flow_api.g_varchar2_table(3) := '6E7461696E6572207B0A2020637572736F723A206D6F76653B0A7D0A0A2E63726F7069742D707265766965772D6261636B67726F756E64207B0A20206F7061636974793A202E323B0A2020637572736F723A206175746F3B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(58969402769171278)
,p_plugin_id=>wwv_flow_api.id(58965461584995705)
,p_file_name=>'at-cropit.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
