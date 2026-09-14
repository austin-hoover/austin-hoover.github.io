-- Preserve the CV's two-column entry layout when Pandoc writes LaTeX.

local function has_class(div, name)
  for _, class in ipairs(div.classes) do
    if class == name then
      return true
    end
  end
  return false
end

local function raw_latex(value)
  return pandoc.RawBlock("latex", value)
end

function Div(div)
  if not FORMAT:match("latex") then
    return nil
  end

  if has_class(div, "cv-contact") then
    local blocks = pandoc.List({raw_latex("\\begin{center}\\small")})
    blocks:extend(div.content)
    blocks:insert(raw_latex("\\end{center}"))
    return blocks
  end

  if not has_class(div, "cv-entry") then
    return nil
  end

  local year = div.content[#div.content]
  if not year or year.t ~= "Div" or not has_class(year, "cv-year") then
    return nil
  end

  div.content:remove(#div.content)

  local blocks = pandoc.List({
    raw_latex("\\noindent\\begin{minipage}[t]{\\dimexpr\\linewidth-2.55cm\\relax}")
  })
  blocks:extend(div.content)
  blocks:insert(raw_latex("\\end{minipage}\\hfill\\begin{minipage}[t]{2.1cm}\\raggedleft"))
  blocks:extend(year.content)
  blocks:insert(raw_latex("\\end{minipage}\\par\\vspace{0.65em}"))

  return blocks
end
