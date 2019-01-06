
local commands = {
    ['pdf']  = 'pdftotext -layout -nopgbrk "$FILE" -', 
    ['doc']  = 'catdoc -w  "$FILE"', 
    ['rtf']  = 'catdoc -w  "$FILE"', 
    ['docx'] = 'docx2txt "$FILE" -', 
    ['odt']  = 'odt2txt "$FILE"', 
    ['djv']  = 'djvused -e print-pure-txt "$FILE"', 
    ['djvu'] = 'djvused -e print-pure-txt "$FILE"', 
}

function ContentGetSupportedField(FieldIndex)
    if (FieldIndex == 0) then
        return 'Text', '', 9; -- FieldName,Units,ft_fulltext
    end
    return '', '', 0; -- ft_nomorefields
end

function ContentGetDetectString()
    local detect_string = '';
    for ext in pairs(commands) do
        if (detect_string == '') then
            detect_string = '(EXT="' .. ext:upper() .. '")';
        else
            detect_string = detect_string .. ' | (EXT="' .. ext:upper() .. '")';
        end
    end
    return detect_string; -- return detect string
end

function ContentGetValue(FileName, FieldIndex, UnitIndex, flags)
    if not SysUtils.DirectoryExists(FileName) and (UnitIndex == 0) then
        local ext = FileName:match(".+%.(.+)$");
        if (ext ~= nil) and (commands[ext] ~= nil) then
            local handle = io.popen(commands[ext]:gsub("$FILE", FileName), 'r');
            local result = handle:read("*a");
            handle:close();
            return result;
        end
    end
    return nil; -- invalid
end