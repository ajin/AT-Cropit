/**
 * Render the placeholder of the plugin during the page load
 *
 * @param p_item
 * @param p_plugin
 * @param p_value
 * @param p_is_readonly
 * @param p_is_printer_friendly
 * @return t_page_item_render_result result type for the rendering function of a region type plug-in
 */
function render (
    p_item                in apex_plugin.t_page_item,
    p_plugin              in apex_plugin.t_plugin,
    p_value               in varchar2,
    p_is_readonly         in boolean,
    p_is_printer_friendly in boolean
) return apex_plugin.t_page_item_render_result is

  c_plugin_namespace  varchar2(200)    := 'at_cropit';
  l_output_html			  varchar2(32767)  := null;
  l_output_js         varchar2(32767)  := null;
  l_result            apex_plugin.t_page_item_render_result;

  c_item_uid          number           := p_item.id; --uid
  c_item_name         varchar2(255)    := p_item.name; --P1_NAME

  c_item_page_id      varchar2(30)     := apex_plugin.get_input_name_for_page_item(p_is_multi_value => false); -- p_t01
  c_ajax_identifier		varchar2(254)    := apex_plugin.get_ajax_identifier;

  -- constant values
  c_item_class		varchar2(254)  := 'image-editor ';
  c_item_div      varchar2(254)  := '<div class="#CLASS#" id="at_cropit_#ID#">
        <input type="file" class="cropit-image-input" id="#ID#" name="#NAME#">
        <div class="cropit-preview"></div>
      </div>';

  -- attributes defined section option
  l_attr_width      varchar2(40)  := p_item.attribute_01;
  l_attr_height     varchar2(40)  := p_item.attribute_02;
  l_attr_image_background varchar2(1)  := p_item.attribute_03;
  l_attr_image_bg_br_width varchar2(40)  := p_item.attribute_04;
  l_attr_export_zoom      varchar2(40)  := p_item.attribute_05;
  l_attr_allow_dragndrop  varchar2(1)   := p_item.attribute_06;
  l_attr_min_zoom         varchar2(40)  := p_item.attribute_07;
  l_attr_max_zoom         varchar2(40)  := p_item.attribute_08;
  l_attr_initial_zoom     varchar2(40)  := p_item.attribute_09;
  l_attr_free_move        varchar2(1)   := p_item.attribute_10;
  l_attr_small_image      varchar2(255) := p_item.attribute_11;

  l_attr_image_type       varchar2(255) := nvl(p_item.attribute_12, 'image/png');
  l_attr_image_quality    varchar2(40)  := nvl(p_item.attribute_13, '0.75');
  l_attr_original_size    varchar2(1)   := p_item.attribute_14;

begin
  apex_debug.message( c_plugin_namespace || ' @ begin' );
  apex_debug.message( c_plugin_namespace || ' @ building html code' );

  l_output_html := replace(c_item_div, '#ID#', c_item_name);
  l_output_html := replace(l_output_html, '#NAME#', c_item_page_id);
  l_output_html := replace(l_output_html, '#CLASS#', c_item_class || p_item.element_css_classes) ;

  apex_debug.message( c_plugin_namespace || ' @ l_output_html: ' || l_output_html );
  sys.htp.p(l_output_html);

  l_output_js := 'atcropit("at_cropit_' || c_item_name || '", {';
  l_output_js := l_output_js || apex_javascript.add_attribute('ajax_identifier', c_ajax_identifier);
  l_output_js := l_output_js || apex_javascript.add_attribute('type', l_attr_image_type);
  l_output_js := l_output_js || apex_javascript.add_attribute('quality', l_attr_image_quality);
  l_output_js := l_output_js || apex_javascript.add_attribute('originalSize', case when l_attr_original_size = 'Y' then true else false end);

  l_output_js := l_output_js || apex_javascript.add_attribute('defaultImageSrc', p_value);

  if l_attr_width is not null then
    l_output_js := l_output_js || apex_javascript.add_attribute('width', l_attr_width);
  end if;

  if l_attr_height is not null then
    l_output_js := l_output_js || apex_javascript.add_attribute('height', l_attr_height);
  end if;

  l_output_js := l_output_js || apex_javascript.add_attribute('imageBackground', case when l_attr_image_background = 'Y' then true else false end );
  l_output_js := l_output_js || apex_javascript.add_attribute('imageBackgroundBorderWidth', l_attr_image_bg_br_width);
  l_output_js := l_output_js || apex_javascript.add_attribute('exportZoom', l_attr_export_zoom);
  l_output_js := l_output_js || apex_javascript.add_attribute('allowDragNDrop', case when l_attr_allow_dragndrop = 'Y' then true else false end );
  l_output_js := l_output_js || apex_javascript.add_attribute('minZoom', l_attr_min_zoom);
  l_output_js := l_output_js || apex_javascript.add_attribute('maxZoom', l_attr_max_zoom);
  l_output_js := l_output_js || apex_javascript.add_attribute('initialZoom', l_attr_initial_zoom);
  l_output_js := l_output_js || apex_javascript.add_attribute('freeMove',  case when l_attr_free_move = 'Y' then true else false end);
  l_output_js := l_output_js || apex_javascript.add_attribute('smallImage', l_attr_small_image);

  l_output_js := l_output_js || '});';

  apex_javascript.add_onload_code( p_code => l_output_js);

  apex_debug.message( c_plugin_namespace || ' @ end' );
  return null;
end;

function ajax_render (
    p_item   in apex_plugin.t_page_item,
    p_plugin in apex_plugin.t_plugin )
return apex_plugin.t_page_item_ajax_result is

  c_plugin_namespace  varchar2(200)    := 'at_cropit @ ajax_render';
  c_item_uid          number           := p_item.id; --uid
  c_item_name         varchar2(255)    := p_item.name; --P1_NAME

  l_clob              clob;
  l_blob              blob;
  l_part              varchar2(32000);

  l_filename          varchar2(200);
  l_mime_type         varchar2(200);

begin

  apex_debug.message( c_plugin_namespace || ' @ begin' );
  apex_debug.message( c_plugin_namespace || ' @ collection_name ' || c_item_name);
  apex_debug.message( c_plugin_namespace || ' @ g_x01 ' || apex_application.g_x01);
  apex_debug.message( c_plugin_namespace || ' @ g_x02 ' || apex_application.g_x02);

  l_filename  := apex_application.g_x01;
  l_mime_type := apex_application.g_x02;

  -- use only for uploading files/image
  dbms_lob.createtemporary(l_clob, false, dbms_lob.session);
  apex_debug.message( c_plugin_namespace || ' @ g_f01.count ' || apex_application.g_f01.count);

  for i in 1..apex_application.g_f01.count loop
    l_part := apex_application.g_f01(i);
    if length(l_part) > 0 then
      dbms_lob.writeappend(l_clob, length(l_part), l_part);
    end if;
  end loop;

  -- convert base64 CLOB to BLOB
  l_blob := apex_web_service.clobbase642blob(p_clob => l_clob);
  apex_debug.message( c_plugin_namespace || ' @ blob length ' || dbms_lob.getlength(l_blob));

  -- register collection with item name
  apex_collection.create_or_truncate_collection(p_collection_name => c_item_name);

  -- add collection member (only if BLOB is not null)
  if dbms_lob.getlength(l_blob) is not null then
    apex_collection.add_member(
      p_collection_name => c_item_name,
      p_c001 => l_filename,
      p_c002 => l_mime_type,
      p_blob001 => l_blob
    );
  end if;

  -- build return JSON value
  apex_json.open_object;
  apex_json.write('result', 'success');
  apex_json.close_object;
  return null;

  apex_debug.message( c_plugin_namespace || ' @ end' );

end;
