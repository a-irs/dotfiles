-- always use "compact lists", for example:
--
-- - item1
-- - item2
-- <blank line>
-- - item3
-- - item4
--
-- normally generates <li><p>item1</p></li> ...
-- now, it generates compact lists: <li>item1</li> ...

local List = require 'pandoc.List'

function compactifyItem (blocks)
  return (#blocks == 1 and blocks[1].t == 'Para')
    and {pandoc.Plain(blocks[1].content)}
    or blocks
end

function compactifyList (l)
  l.content = List.map(l.content, compactifyItem)
  return l
end

return {{
    BulletList = compactifyList,
    OrderedList = compactifyList
}}
