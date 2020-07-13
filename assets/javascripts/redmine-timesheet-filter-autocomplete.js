$(document).ready(function() {
    setTimeout(function() {
        var $autocompleteInput = $('<input class="input-autocomplete value" name="input_autocomplete" size="20"/>');
        var $autocompleteFilter = $('<tr id="tr_autocomplete" class="filter"></tr>');
        $autocompleteFilter.append($('<td class="field"><label for="input_autocomplete">Search</label></td>'));
        $autocompleteFilter.append($('<td class="value"></td>'));
        $autocompleteFilter.children('.value').append($autocompleteInput);
        $('#filters-table tbody').prepend($autocompleteFilter);

        // Autocomplete source.
        var source = '/timesheet/filter/autocomplete';
        const regex = /^\/projects\/(.+)\//;
        var matches;
        if ((matches = regex.exec(window.location.pathname)) !== null) {
            if (matches[1]) {
                source = '/timesheet/filter/' + matches[1] + '/autocomplete';
            }
        }
        
        $autocompleteInput.autocomplete({
            autoFocus: true,
            delay: 300,
            minLength: 2,
            source: source,
            select: function(event, ui) {
                var id = ui.item.id;
                var parts = id.split('/');
                if (parts.length === 3) {
                    var filter_id = parts[0];
                    var operator = parts[1];
                    var value = parts[2];
                    var urlParams = new URLSearchParams(window.location.search);
                    var filterExists = false;
                    for (paramValue in urlParams.getAll('f[]')) {
                        if (paramValue == filter_id) {
                            filterExists = true;
                        }
                    }
                    if (!filterExists) {
                      urlParams.append('f[]', filter_id);
                    }
                    urlParams.set('op[' + filter_id + ']', operator);
                    if (value) {
                        urlParams.set('v[' + filter_id + '][]', value);
                    }
                    if (issue_id_value = urlParams.get('issue_id')) {
                        // Handle if coming from issue time entries.
                        urlParams.append('f[]', 'issue_id');
                        urlParams.set('op[issue_id]', '~');
                        urlParams.append('v[issue_id][]', issue_id_value.substring(1));
                        urlParams.delete('issue_id');
                    }
                    window.location.href = window.location.origin + window.location.pathname + '?' + urlParams.toString();
                }
            }
        });
    }, 200);

});