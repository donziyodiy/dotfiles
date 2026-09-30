require("cairo")

local colors = {
    primary = 0xFFFFFF,
    secondary = 0xB8C0CC,
    muted = 0x7F8999,
    accent = 0x89B4FA,
}

local month_names = {
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
}

local weekday_names = {
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
    "Su",
}

local function set_color(cr, color, alpha)
    local red = math.floor(color / 0x10000) % 0x100
    local green = math.floor(color / 0x100) % 0x100
    local blue = color % 0x100

    cairo_set_source_rgba(
        cr,
        red / 255,
        green / 255,
        blue / 255,
        alpha or 1
    )
end

local function draw_text(
    cr,
    value,
    x,
    y,
    size,
    color,
    bold,
    centered
)
    cairo_select_font_face(
        cr,
        "DejaVu Sans Mono",
        CAIRO_FONT_SLANT_NORMAL,
        bold and CAIRO_FONT_WEIGHT_BOLD
        or CAIRO_FONT_WEIGHT_NORMAL
    )

    cairo_set_font_size(cr, size)
    set_color(cr, color)

    if centered then
        local extents = cairo_text_extents_t:create()
        cairo_text_extents(cr, value, extents)

        x = x
            - extents.width / 2
            - extents.x_bearing
    end

    cairo_move_to(cr, x, y)
    cairo_show_text(cr, value)
end

local function timestamp(year, month, day)
    return os.time({
        year = year,
        month = month,
        day = day,
        hour = 12,
    })
end

function conky_draw_calendar()
    if conky_window == nil then
        return
    end

    local surface = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )

    local cr = cairo_create(surface)

    cairo_set_antialias(
        cr,
        CAIRO_ANTIALIAS_BEST
    )

    local width = conky_window.width
    local center = width / 2
    local now = os.date("*t")

    -- Time
    draw_text(
        cr,
        os.date("%H:%M"),
        center,
        58,
        52,
        colors.primary,
        true,
        true
    )

    -- Full date
    draw_text(
        cr,
        os.date("%A, %d %B %Y"),
        center,
        90,
        14,
        colors.secondary,
        false,
        true
    )

    -- Calendar month title
    local month_heading =
        month_names[now.month]
        .. " "
        .. tostring(now.year)

    draw_text(
        cr,
        month_heading,
        center,
        137,
        18,
        colors.primary,
        true,
        true
    )

    -- Calendar geometry
    local cell_width = 43
    local row_height = 31
    local column_count = 8
    local grid_width = cell_width * column_count
    local start_x = (width - grid_width) / 2
    local header_y = 174
    local first_row_y = 208

    -- Week-number heading
    draw_text(
        cr,
        "Wk",
        start_x + cell_width / 2,
        header_y,
        12,
        colors.muted,
        true,
        true
    )

    -- Weekday headings
    for column = 1, 7 do
        local x =
            start_x
            + column * cell_width
            + cell_width / 2

        draw_text(
            cr,
            weekday_names[column],
            x,
            header_y,
            12,
            colors.secondary,
            true,
            true
        )
    end

    local first_day = os.date(
        "*t",
        timestamp(now.year, now.month, 1)
    )

    -- Convert Sunday=1 into:
    -- Monday=0, Tuesday=1, ..., Sunday=6
    local first_offset =
        (first_day.wday + 5) % 7

    local days_in_month = os.date(
        "*t",
        timestamp(now.year, now.month + 1, 0)
    ).day

    local rows = math.ceil(
        (first_offset + days_in_month) / 7
    )

    for row = 0, rows - 1 do
        local y =
            first_row_y
            + row * row_height

        -- ISO week number
        local monday = timestamp(
            now.year,
            now.month,
            1 - first_offset + row * 7
        )

        local week_number =
            os.date("%V", monday)

        draw_text(
            cr,
            week_number,
            start_x + cell_width / 2,
            y,
            12,
            colors.muted,
            false,
            true
        )

        -- Dates
        for column = 0, 6 do
            local day =
                row * 7
                + column
                - first_offset
                + 1

            if day >= 1
                and day <= days_in_month
            then
                local x =
                    start_x
                    + (column + 1) * cell_width
                    + cell_width / 2

                local is_today =
                    day == now.day

                local displayed_day

                if is_today then
                    displayed_day =
                        "["
                        .. tostring(day)
                        .. "]"
                else
                    displayed_day =
                        tostring(day)
                end

                draw_text(
                    cr,
                    displayed_day,
                    x,
                    y,
                    14,
                    is_today
                    and colors.accent
                    or colors.secondary,
                    is_today,
                    true
                )
            end
        end
    end

    cairo_destroy(cr)
    cairo_surface_destroy(surface)
end
