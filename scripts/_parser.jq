# Apply $filter to input
# <- downloads.json | evaluate_filter("plugins")
# -> [["internal", "plugins/Extras.jar", "type"], "zip"]
# -> [["internal", "plugins/Extras.jar", "url"], "..."]
# -> [["internal", "plugins/Extras.jar", "url"]]
# -> [["internal", "plugins/Extras.jar"]]
# -> [["internal"]]
def evaluate_filter($filter):
    $filter | indices("/") | length
    | truncate_stream(
        inputs
        | select(
            .[0] as $key
            | $key | join("/")
            | startswith($filter)));

# Flatten stream structure, stripping everything but the download
# path and it's properties
# <- [["internal", "plugins/Extras.jar", "type"], "zip"]
# <- [["internal", "plugins/Extras.jar", "url"], "..."]
# <- [["internal", "plugins/Extras.jar"]]
# <- [["internal"]]
# -> [["plugins/Extras.jar", "type"], "zip"]
# -> [["plugins/Extras.jar", "url"], "..."]
def get_downloads_obj:
    select(length == 2)
    | del(.[0][:-2]);

# Reduce flattened stream to an object
# <- [["plugins/Extras.jar", "type"], "zip"]
# <- [["plugins/Extras.jar", "url"], "..."]
# -> { "plugins/Extras.jar": {"type": "zip", "url": "..."} }
def reduce_to_object(stream):
    reduce stream as $in ({};
        setpath($in[0]; $in[1]));

# Turn object into a bash-readable string
# <- { "plugins/Extras.jar": {"type": "zip"} }
# -> plugins/Extras.jar
# zip
# { "url": ... }
def print_bash:
    to_entries[]
    | (.value | del(.type)) as $args
    | "\(.key)\n\(.value.type)\n\($args)";

reduce_to_object(
    if $arg1 == ""
        then inputs
        else evaluate_filter($arg1) end
    | get_downloads_obj)
| print_bash
