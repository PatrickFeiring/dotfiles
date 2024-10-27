local luasnip = prequire("luasnip")

if not luasnip then
    return
end

local s = luasnip.snippet
local sn = luasnip.snippet_node
local i = luasnip.insert_node
local f = luasnip.function_node
local t = luasnip.text_node

local c = require("user.snippets.conditions")
local conditions = require("luasnip.extras.expand_conditions")
local filetype_functions = require("luasnip.extras.filetype_functions")

local function copy(args)
    return args[1]
end

local function between(...)
    local args = { ... }
    local nodes = {}

    for j, arg in ipairs(args) do
        table.insert(nodes, t(arg))

        if j < #args then
            table.insert(nodes, i(j))
        end
    end

    return nodes
end

local function function_call(name)
    return { t(name .. "("), i(1), t(");") }
end

local function function_call_no_semicolon(name)
    return { t(name .. "("), i(1), t(")") }
end

local function line_between(above, below)
    return { sn(1, above), t({ "", "" }), i(2), t({ "", "" }), sn(3, below) }
end

local function regex_capture(opts)
    opts = opts or {}

    local index = opts.i or 1
    local prefix = opts.prefix or ""
    local suffix = opts.suffix or ""

    local handler = function(_args, snip)
        return prefix .. snip.captures[index] .. suffix
    end

    return f(handler)
end

luasnip.config.set_config({
    ft_func = filetype_functions.from_pos_or_filetype,
})

local cpp_snippets = {
    s("foracrs", {
        t("for (auto const &"),
        i(1),
        t(" : "),
        f(copy, 1),
        t({ "s) {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("foracr", {
        t("for (auto const &"),
        i(1),
        t({ ") {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("unused", t("__attribute__((unused))")),
    s("forar", {
        t("for (auto &"),
        i(1),
        t({ ") {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("foras", {
        t("for (auto "),
        i(1),
        t(" : "),
        f(copy, 1),
        t({ "s) {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("forsi", {
        t("for (size_t i = 0; i < "),
        i(1),
        t({ "; i++) {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("wcout", between("std::wcout << ", " << std::endl;")),
    s("cerr", between("std::cerr << ", " << std::endl;")),
    s("cout", between("std::cout << ", " << std::endl;")),
    s("endl", t("std::endl")),
    s("fora", {
        t("for (auto "),
        i(1),
        t({ ") {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("fori", {
        t("for (int i = 0; i < "),
        i(1),
        t({ "; i++) {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("main", {
        t({ "int main(int argc, char **argv)", "{", "    " }),
        i(1),
        t({ "", "", "    return 0;", "}" }),
    }),
    s("ibh", between("#include <", ".hpp>")),
    s("sno", t("std::nullopt")),
    s("sum", between("std::unordered_map<", ">")),
    s("sup", between("std::unique_ptr<", ">")),
    s("sus", between("std::unordered_set<", ">")),
    s("fr", function_call("free")),
    s("hv", t("has_value()")),
    s("ia", between('#include "', '.hpp"')), -- TODO: fix to get alternate automatically
    s("ib", between("#include <", ">")),
    s("ih", between('#include "', '.hpp"')),
    s("np", t("nullptr")),
    s("pb", function_call("push_back")),
    s("rf", t("return false;")),
    s("rt", t("return true;")),
    s("sm", between("std::map<", ">")),
    s("so", between("std::optional<", ">")),
    s("sp", between("std::pair<", ">")),
    s("ss", t("std::string")),
    s("st", between("std::tuple<", ">")),
    s("sv", between("std::vector<", ">")),
    s("ws", t("std::wstring")),
    s("b", t("bool")),
    s("c", t("const ")),
    s("d", t("delete")),
    s("f", t("false")),
    s("i", t("#include ")),
    s("r", t("return")),
    s("s", t("std::")),
    s("t", t("true")),
    s("v", t("value()")),
}

luasnip.add_snippets("cpp", cpp_snippets)
-- We don't have a treesitter grammar for lex yet, so we can't
-- distinguish between the different blocks, therefore we just copy all
-- the snippets right now
luasnip.add_snippets("lex", cpp_snippets)

local css_snippets = {
    s("posa", t("position: absolute;")),
    s("posr", t("position: relative;")),
    s("dib", t("display: inline-block;")),
    s("fsi", t("font-style: italic;")),
    s("pic", t("place-items: center;")),
    s("tal", t("text-align: left;")),
    s("ai", between("align-items: ", ";")),
    s("br", between("border-radius: ", ";")),
    s("bg", between("background: ", ";")),
    s("cp", t("cursor: pointer;")),
    s("db", t("display: block;")),
    s("df", t("display: flex;")),
    s("dg", t("display: grid;")),
    s("dn", t("display: none;")),
    s("ff", between("font-family: ", ";")),
    s("fs", between("font-size: ", ";")),
    s("fw", between("font-weight: ", ";")),
    s("ga", between("grid-area: ", ";")),
    s("jc", between("justify-content: ", ";")),
    s("lh", between("line-height: ", ";")),
    s("ma", t("margin: auto;")),
    s("mb", between("margin-bottom: ", ";")),
    s("ml", between("margin-left: ", ";")),
    s("mr", between("margin-right: ", ";")),
    s("mt", between("margin-top: ", ";")),
    s("pb", between("padding-bottom: ", ";")),
    s("pl", between("padding-left: ", ";")),
    s("pr", between("padding-right: ", ";")),
    s("pt", between("padding-top: ", ";")),
    s("ta", between("text-align: ", ";")),
    s("b", between("border: 1px solid ", ";")),
    s("m", between("margin: ", ";")),
    s("p", between("padding: ", ";")),
    s("v", between("var(--", ");")),
}

luasnip.add_snippets("css", css_snippets)
luasnip.add_snippets("scss", css_snippets)

luasnip.add_snippets("edgeql", {
    s(
        "rp",
        between("required property ", " -> "),
        { condition = conditions.line_begin }
    ),
    s(
        "rl",
        between("required link ", " -> "),
        { condition = conditions.line_begin }
    ),
    s(
        "md",
        line_between(t("module default {"), t("}")),
        { condition = conditions.line_begin }
    ),
    s(
        "at",
        t('annotation title := "', '";'),
        { condition = conditions.line_begin }
    ),
    s(
        "ad",
        t('annotation description := "', '";'),
        { condition = conditions.line_begin }
    ),
    s("r", t("required "), { condition = conditions.line_begin }),
    s(
        "t",
        line_between(between("type ", " {"), t("}")),
        { condition = conditions.line_begin }
    ),
    s("p", between("property ", " -> "), {
        condition = conditions.line_begin,
    }),
    s(
        "m",
        line_between(between("module ", " {"), t("}")),
        { condition = conditions.line_begin }
    ),
    s("l", between("link ", " -> "), { condition = conditions.line_begin }),
    s("a", t("annotation "), { condition = conditions.line_begin }),
})

luasnip.add_snippets("haskell", {
    s(
        "stack",
        t({ "#!/usr/bin/env stack", "-- stack --resolver lts-19.2 script" })
    ),
    s("LDK", t("{-# LANGUAGE DataKinds #-}")),
    s("LKS", t("{-# LANGUAGE KindSignatures #-}")),
    s("LOS", t("{-# LANGUAGE OverloadedStrings #-}")),
    s("ds", t("deriving Show")),
    s("ic", t("import Control.")),
    s("id", t("import Data.")),
    s("in", between("instance ", " where")),
    s("iq", t("import qualified ")),
    s("pu", t("putStrLn ")),
    s(
        "d",
        { t("data "), i(1), t(" = "), f(copy, 1) },
        { condition = conditions.line_begin }
    ),
    s("L", between("{-# LANGUAGE ", " #-}")),
    s("d", between("deriving (", ")")),
    s("i", t("import ")),
    s("p", t("print ")),
    s("r", t("return ")),
})

local html_snippets = {
    s("a", between('<a href="', '">', "</a>")),
    s("#", between('id="', '"')),
    s(".", between('class="', '"')),
}

luasnip.add_snippets("html", html_snippets)
luasnip.add_snippets("htmldjango", html_snippets)

luasnip.add_snippets("java", {
    -- TODO: add current package
    s("forv", {
        t("for (var "),
        i(1),
        t(" : "),
        f(copy, 1),
        t({ "s) {", "    " }),
        i(0),
        t({ "", "}" }),
    }),
    s("pubv", t("public void ")),
    s("pri", t("private ")),
    s("pro", t("protected ")),
    s("pub", t("public ")),
    s("@O", t("@Override")),
    s("ld", function_call("logger.debug")),
    s("le", function_call("logger.error")),
    s("li", function_call("logger.info")),
    s("lw", function_call("logger.warn")),
    s("rf", t("return false;")),
    s("rn", t("return null;")),
    s("rt", t("return true;")),
    s("sf", function_call("String.format")),
    s("r", t("return")),
    s("s", t("static ")),
    s("p", { t("System.out.println("), i(1), t(");") }),
    s("t", t("throws ")),
})

luasnip.add_snippets("oil", {
    s("lsts", t("+layout.server.ts")),
    s("psts", t("+page.server.ts")),
    s("es", t("+error.svelte")),
    s("lts", t("+layout.ts")),
    s("pts", t("+page.ts")),
    s("ls", t("+layout.svelte")),
    s("ps", t("+page.svelte")),
})

local javascript_snippets = {
    s("computed", between("computed(() => ", ");")),
    s(
        "loada",
        line_between(between("export const load = async (", ") => {"), t("}"))
    ),
    s("testa", line_between(between("test('", "', async () => {"), t("})"))),
    s("comp", between("computed(() => ", ");")),
    s("desc", line_between(between("describe('", "', () => {"), t("})"))),
    s("load", line_between(between("export const load = (", ") => {"), t("}"))),
    s("insp", between("$inspect(", ")"), {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("test", line_between(between("test('", "', () => {"), t("})"))),
    s("aaf", between("async (", ") => {", "}")),
    s(
        "edf",
        t("export default function "),
        { condition = conditions.line_begin }
    ),
    s("doc", { t({ "/**", " * " }), i(1), t({ "", " */" }) }),
    s("eld", t("export let data;"), { condition = conditions.line_begin }),
    s("isk", {
        t("import { "),
        i(1),
        t(" } from '@sveltejs/kit;'"),
    }, {
        condition = conditions.line_begin,
    }),
    s("isv", {
        t("import { "),
        i(1),
        t(" } from 'svelte';"),
    }, {
        condition = conditions.line_begin,
    }),
    s("ldb", between("let ", " = $derived.by(() => {", "});"), {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("af", between("(", ") => {", "}")),
    s("cl", function_call("console.log")),
    s("dp", {
        t("defineProps<> "),
        i(1),
        t(" from '@/components/"),
        f(copy, 1),
        t(".vue';"),
    }, {
        condition = conditions.line_begin * c.filetype_is("vue"),
    }),
    s("ec", t("export const "), { condition = conditions.line_begin }),
    s("ed", t("export default "), { condition = conditions.line_begin }),
    s("el", t("export let "), { condition = conditions.line_begin }),
    s("et", t("export type "), { condition = conditions.line_begin }),
    s("ei", t("export interface "), { condition = conditions.line_begin }),
    s("ia", {
        t("import "),
        i(1),
        t(" from '$lib/assets/"),
        i(2),
        f(copy, 1),
        i(3),
        t("';"),
    }, {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("ic", {
        t("import "),
        i(1),
        t(" from '@/components/"),
        i(2),
        f(copy, 1),
        t(".vue';"),
    }, {
        condition = conditions.line_begin * c.filetype_is("vue"),
    }),
    s("ic", {
        t("import "),
        i(1),
        t(" from '$lib/components/"),
        i(2),
        f(copy, 1),
        t(".svelte';"),
    }, {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s(
        "id",
        between("import ", " from '", "';"),
        { condition = conditions.line_begin }
    ),
    s("il", {
        t("import { "),
        i(1),
        t(" } from '$lib/"),
        i(2),
        t("';"),
    }, { condition = conditions.line_begin }),
    s(
        "it",
        between("import type { ", ' } from "', '";'),
        { condition = conditions.line_begin }
    ),
    s(
        "iv",
        { t("import "), i(1), t(' from "@/views/"'), f(copy, 1), t(".vue;") },
        { condition = conditions.line_begin }
    ),
    s("ld", between("let ", " = $derived();"), {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("lp", between("let { ", " } = $props();"), {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("ls", between("let ", " = $state(", ");"), {
        condition = conditions.line_begin * c.filetype_is("svelte"),
    }),
    s("oe", function_call_no_semicolon("Object.entries")),
    s("ok", function_call_no_semicolon("Object.keys")),
    s("ov", function_call_no_semicolon("Object.values")),
    s("re", t("return [];")),
    s("rf", t("return false;")),
    s("rn", t("return null;")),
    s("ro", between("return { ", " };")),
    s("rt", t("return true;")),
    s("ru", t("return undefined;")),
    s("a", t("await ")),
    s("c", t("const ")),
    s("e", t("export ")),
    s("f", t("false")),
    s(
        "i",
        { t("import { "), i(1), t(" } from '"), i(2), t("';") },
        { condition = conditions.line_begin }
    ),
    s("r", between("return", ";")),
    s("t", t("true")),
}

luasnip.add_snippets("javascript", javascript_snippets)
luasnip.add_snippets("tsx", javascript_snippets)
luasnip.add_snippets("typescript", javascript_snippets)
luasnip.add_snippets("typescriptreact", javascript_snippets)

luasnip.add_snippets("lua", {
    s("req", between("require('", "')")),
    s("lf", {
        t("local function "),
        i(1),
        t("("),
        i(2),
        t({ ")", "    " }),
        i(0),
        t({ "", "end" }),
    }),
    s("rf", t("return false")),
    s("rn", t("return nil")),
    s("rt", t("return true")),
    s("f", t("false")),
    s("l", t("local ")),
    s("p", function_call_no_semicolon("print")),
    s("r", t("return")),
    s("t", t("true")),
})

local markdown_snippets = {
    s("python", line_between(t("```python"), t("```"))),
    s("svelte", line_between(t("```svelte"), t("```"))),
    s("bash", line_between(t("```bash"), t("```"))),
    s("html", line_between(t("```html"), t("```"))),
    s("json", line_between(t("```json"), t("```"))),
    s("rust", line_between(t("```rust"), t("```"))),
    s("yaml", line_between(t("```yaml"), t("```"))),
    s("css", line_between(t("```css"), t("```"))),
    s("sql", line_between(t("```sql"), t("```"))),
    s("ts", line_between(t("```typescript"), t("```"))),
    s("py", line_between(t("```python"), t("```"))),
    s("a", { t("["), i(1, "description"), t("]("), i(2, "link"), t(")") }),
}

luasnip.add_snippets("markdown", markdown_snippets)
luasnip.add_snippets("markdown_inline", markdown_snippets)

luasnip.add_snippets("php", {
    s("dvd", between("die(var_dump(", "));")),
    s("isn", function_call_no_semicolon("is_null")),
    s("vd", function_call_no_semicolon("var_dump")),
    s("d", function_call("die")),
    s("e", function_call("echo")),
    s("v", between("$", " = ")),
})

luasnip.add_snippets("python", {
    s("fors", {
        t("for "),
        i(1),
        t(" in "),
        f(copy, 1),
        t({ "s:", "    " }),
        i(2),
    }),
    s("init", t({ "def __init__(self):", "    " })),
    s("isnn", t("is not None")),
    s("main", { t({ "if __name__ == '__main__':", "    " }), i(1) }),
    s("cls", t("@classmethod")),
    s("doc", { t('"""'), i(1), t('"""') }),
    s("isn", t("is None")),
    s("bp", t("breakpoint()")),
    s(
        "fi",
        { t("from "), i(1), t(" import ") },
        { condition = conditions.line_begin }
    ),
    s("l0", { t("len("), i(1), t(") == 0") }),
    s("ld", function_call_no_semicolon("logger.debug")),
    s("le", function_call_no_semicolon("logger.error")),
    s("li", function_call_no_semicolon("logger.info")),
    s("lw", function_call_no_semicolon("logger.warning")),
    s("pv", t({ "self._", i(1), " = ", i(1) })),
    s("rf", t("return False")),
    s("rn", t("return None")),
    s("rt", t("return True")),
    s("sm", t("@staticmethod")),
    s(
        "wo",
        { t("with open("), i(1), t(") as f:") },
        { condition = conditions.line_begin }
    ),
    s("b", t("break"), { condition = conditions.line_begin }),
    s("c", t("continue"), { condition = conditions.line_begin }),
    s("e", t("except"), { condition = conditions.line_begin }),
    s("i", t("import "), { condition = conditions.line_begin }),
    s("l", function_call_no_semicolon("len")),
    s(
        "p",
        function_call_no_semicolon("print"),
        { condition = conditions.line_begin }
    ),
    s("r", t("return"), { condition = conditions.line_begin }),
})

luasnip.add_snippets("rust", {
    s("ddsd", t("#[derive(Debug, Serialize, Deserialize)]")),
    s("fors", {
        t("for "),
        i(1),
        t(" in "),
        f(copy, 1),
        t({ "s {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s(
        "tests",
        line_between(
            t({ "#[cfg(test)]", "mod tests {", "    use super::*;", "" }),
            t("}")
        )
    ),
    s(
        "test",
        line_between(
            t({
                "#[test]",
                "fn () {",
            }),
            t("}")
        )
    ),
    s(".ts", t(".to_string()")),
    s("ddd", t("#[derive(Debug, Deserialize)]")),
    s("dds", t("#[derive(Debug, Serialize)]")),
    s("for", {
        t("for "),
        i(1),
        t(" in "),
        f(copy, 1),
        t({ " {", "    " }),
        i(2),
        t({ "", "}" }),
    }),
    s("pan", function_call("panic!")),
    s("ppd", between('println!("{:#?}", ', ");")),
    s("af", t("async fn")),
    s("db", between("dbg!(", ")")),
    s("dd", t("#[derive(Debug)]")),
    s("ec", t("extern crate ")),
    s("fo", function_call("format!")),
    s("ld", function_call("debug!")),
    s("le", function_call("error!")),
    s("li", function_call("info!")),
    s("lm", t("let mut ")),
    s("lw", function_call("warn!")),
    s("pd", between('println!("{:?}", ', ");")),
    s(
        "pe",
        { t("pub enum "), i(1), t({ " {", "    " }), i(2), t({ "", "}" }) },
        { condition = conditions.line_begin }
    ),
    s("pf", t("pub fn ")),
    s(
        "ps",
        { t("pub struct "), i(1), t({ " {", "    " }), i(2), t({ "", "}" }) },
        { condition = conditions.line_begin }
    ),
    s("pm", t("pub mod ")),
    s("pp", between('println!("{:#?}", ', ");")),
    s("rf", t("return false;")),
    s("rn", t("return None;")),
    s("rt", t("return true;")),
    s("vn", t("Vec::new()")),
    s(".e", function_call(".expect")),
    s(".u", t(".unwrap()")),
    s("a", between("#[", "]")),
    s("c", t("continue;"), { condition = conditions.line_begin }),
    s("d", between("#[derive(", ")]"), { condition = conditions.line_begin }),
    s("l", t("let ")),
    s("m", { t("match "), i(1), t({ " {", "" }), i(2), t({ "", "}" }) }),
    s(
        "s",
        { t("struct "), i(1), t({ " {", "    " }), i(2), t({ "", "}" }) },
        { condition = conditions.line_begin }
    ),
    s("p", function_call("println!")),
    s("r", between("return", ";")),
    s("u", between("use ", ";"), { condition = conditions.line_begin }),
})

luasnip.add_snippets("sql", {
    s("ondup", t("ON DUPLICATE KEY UPDATE ")),
    s("scfgb", {
        t("SELECT "),
        i(1),
        t(", COUNT(*) AS cnt FROM "),
        i(2),
        t(" GROUP BY "),
        f(copy, 1),
    }),
    s("case", {
        t({ "CASE", "" }),
        t("    WHEN "),
        i(1),
        t(" THEN "),
        i(2),
        t({ "", "    ELSE " }),
        i(3),
        t({ "", "END" }),
    }),
    s("isnn", t("IS NOT NULL ")),
    s(
        "shct",
        { t("SHOW CREATE TABLE "), i(1), t(";") },
        { condition = conditions.line_begin }
    ),
    s(
        "shtf",
        { t("SHOW TABLES FROM "), i(1), t(";") },
        { condition = conditions.line_begin }
    ),
    s(
        "shtl",
        between("SHOW TABLES LIKE '%", "%';"),
        { condition = conditions.line_begin }
    ),
    s("some", t("LIMIT 20")),
    s("fst", { t("((1 << 31) - "), i(1), t(" - 1)") }),
    s("iii", t("INSERT IGNORE INTO "), { condition = conditions.line_begin }),
    s("isn", t("IS NULL ")),
    s("nlc", { t("NOT LIKE '%"), i(1), t("%'") }),
    s("one", t("LIMIT 1\\G")),
    s("scf", { t("SELECT COUNT(*) AS cnt FROM ") }),
    s("sdf", { t("SELECT DISTINCT "), i(1), t(" FROM ") }),
    s("sht", { t("SHOW TABLES;") }, { condition = conditions.line_begin }),
    s("ssf", { t("SELECT * FROM ") }),
    s("ai", t("AUTO_INCREMENT ")),
    s("cc", t("COUNT(*) AS cnt ")),
    s("cr", t("CREATE TABLE ")),
    s("at", t("ALTER TABLE "), { condition = conditions.line_begin }),
    s("df", t("DELETE FROM "), { condition = conditions.line_begin }),
    s("je", { t("JSON_EXTRACT("), i(1), t(")") }),
    s("ii", t("INSERT INTO "), { condition = conditions.line_begin }),
    s("ij", t("INNER JOIN ")),
    s("lc", { t("LIKE '%"), i(1), t("%'") }),
    s("lj", t("LEFT JOIN ")),
    s("rj", t("RIGHT JOIN ")),
    s("gb", t("GROUP BY ")),
    s("fu", { t("FROM_UNIXTIME("), i(1), t(")") }),
    s("nl", t("NOT LIKE ")),
    s("nn", t("NOT NULL ")),
    s("ob", t("ORDER BY ")),
    s("pk", t("PRIMARY KEY ")),
    s("st", t("stimestamp ")),
    s("sf", { t("SELECT "), i(1), t(" FROM ") }),
    s("ut", t("UNIX_TIMESTAMP() ")),
    s("a", t("ASC ")),
    s("b", { t("BETWEEN "), i(1), t(" AND "), i(2) }),
    s(
        "d",
        { t("DESCRIBE "), i(1), t(";") },
        { condition = conditions.line_begin }
    ),
    s("d", t("DESC ")),
    s("f", t("FROM ")),
    s("h", t("HAVING ")),
    s("l", t("LIKE ")),
    s("t", t("timestamp ")),
    s("s", t("SELECT ")),
    s(
        "u",
        { t("UPDATE "), i(1), t(" SET ") },
        { condition = conditions.line_begin }
    ),
    s("u", between("USING(", ") ")),
    s("v", { t("VALUES("), i(1), t(")") }),
    s("w", t("WHERE ")),
    s(
        { trig = "(%d+)o(%d+)", regTrig = true },
        regex_capture({ prefix = "LIMIT " })
    ),
    s({ trig = "(%d+)", regTrig = true }, regex_capture({ prefix = "LIMIT " })),
})

luasnip.add_snippets("svelte", {
    s("renderc", t("@{render children()}")),
    s("elseif", between("{:else if ", "}")),
    s("render", between("{@render ", "()}")),
    s("await", line_between(between("{#await ", "}"), t("{/await}"))),
    s("debug", between("{@debug ", "}")),
    s("const", between("{@const ", " = ", "}")),
    s("html", between("{@html ", "}")),
    s(
        "eachs",
        line_between(
            sn(1, { t("{#each "), i(1), t("s as "), f(copy, 1), t("}") }),
            t("{/each}")
        )
    ),
    s("each", line_between(between("{#each ", " as ", "}"), t("{/each}"))),
    s("else", t("{:else}")),
    s("sass", line_between(t('<style lang="sass">'), t("</style>"))),
    s("scss", line_between(t('<style lang="scss">'), t("</style>"))),
    s("css", line_between(t("<style>"), t("</style>"))),
    s("key", line_between(between("{#key ", "}"), t("{/key}"))),
    s("if", line_between(between("{#if ", "}"), t("{/if}"))),
    s(
        "js",
        line_between(t("<script>"), t("</script>")),
        { condition = conditions.line_begin }
    ),
    s(
        "sm",
        line_between(t('<script lang="ts" context="module">'), t("</script>")),
        { condition = conditions.line_begin }
    ),
    s("sw", between("<svelte:window ", " />")),
    s(
        "s",
        line_between(t('<script lang="ts">'), t("</script>")),
        { condition = conditions.line_begin }
    ),
    s("#", between('id=, "', '"')),
    s(".", between('class="', '"')),
})

luasnip.add_snippets("vue", {
    s("sass", line_between(t('<style lang="sass" scoped>'), t("</style>"))),
    s("scss", line_between(t('<style lang="scss" scoped>'), t("</style>"))),
    s("css", line_between(t("<style scoped>"), t("</style>"))),
    s("for", { t('v-for="'), i(1), t('" :key="'), i(2), t('"') }),
    s("if", { t('v-if="'), i(1), t('"') }),
    s(
        "ss",
        line_between(t('<script setup lang="ts">'), t("</script>")),
        { condition = conditions.line_begin }
    ),
    s("ts", line_between(t('<script lang="ts">'), t("</script>"))),
    s("b", t("v-bind")),
    s(
        "t",
        line_between(t("<template>"), t("</template>")),
        { condition = conditions.line_begin }
    ),
    s("#", between('id=, "', '"')),
    s(".", between('class="', '"')),
})

luasnip.add_snippets("xslt", {
    s(
        "otherwise",
        line_between(t("<xsl:otherwise>"), t("</xsl:otherwise>")),
        { conditions = conditions.line_between }
    ),
    s(
        "comment",
        line_between(t("<xsl:comment>"), t("</xsl:comment>")),
        { conditions = conditions.line_between }
    ),
    s(
        "choose",
        line_between(t("<xsl:choose>"), t("</xsl:choose>")),
        { conditions = conditions.line_between }
    ),
    s(
        "when",
        line_between(between('<xsl:when test="', '">'), t("</xsl:when>")),
        { conditions = conditions.line_between }
    ),
    s("apt", between('<xsl:apply-templates select="', '"/>')),
    s("cat", between('<xsl:call-template name="', '"/>')),
    s(
        "var",
        line_between(
            between('<xsl:variable name="', '">'),
            t("</xsl:variable>")
        )
    ),
    s(
        "if",
        line_between(between('<xsl:if test="', '">'), t("</xsl:if>")),
        { conditions = conditions.line_between }
    ),
    s(
        "tn",
        line_between(
            between('<xsl:template name="', '">'),
            t("</xsl:template>")
        )
    ),
    s(
        "tm",
        line_between(
            between('<xsl:template name="', '">'),
            t("</xsl:template>")
        )
    ),
    s(
        "wp",
        between('<xsl:with-param name="', '" select=""/>'),
        { conditions = conditions.line_begin }
    ),
    s("c", between('<xsl:copy-of select="', '"/>')),
    s("C", between("<![CDATA[", "]]>")),
    s(
        "m",
        line_between(
            between('<xsl:template match="', '">'),
            t("</xsl:template>")
        ),
        { conditions = conditions.line_begin }
    ),
    s(
        "p",
        between('<xsl:param name="', '"/>'),
        { conditions = conditions.line_begin }
    ),
    s("t", between("<xsl:text>", "</xsl:text>")),
    s("v", between('<xsl:value-of select="', '"/>')),
})

local typewriter = prequire("typewriter")

local function replace_termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.api.nvim_set_keymap("i", "<Tab>", "", {
    expr = true,
    callback = function()
        if luasnip and luasnip.expandable() then
            return replace_termcodes("<Plug>luasnip-expand-snippet")
        elseif typewriter and typewriter.expandable() then
            return replace_termcodes("<Plug>typewriter-expand")
        else
            return replace_termcodes("<Tab>")
        end
    end,
})

vim.keymap.set("i", "<C-J>", "<Plug>luasnip-jump-next")

require("user.snippets.skeletons")
