# CHANGELOG

## 0.1.10

Bugfix:

- `A4_PORTRAIT_HEIGHT` (and so `A4_LANDSCAPE_WIDTH`) was 15840 twips, which is US Letter's 11 inches; it is now A4's 16838, so documents using the default page size come out on A4
- `w:orient` was written as `"portrait}"` / `"landscape}"` (stray brace), and the `orientation:` passed to `Document.new` was never written at all
- `Document#height` reader added, so `add_page_layout` without an explicit `height:` no longer raises `NoMethodError`
- README showed `page_width:`/`page_height:` (ignored; the options are `width:`/`height:`) and `page_layout` instead of `add_page_layout`

## 0.1.9

Security:

- Require rubyzip 3.6+ (`~> 3.6`), fixing CVE-2026-85396 (path traversal in `Zip::Entry#extract` before rubyzip 3.4.0)

Bugfix:

- Entry sizes are now declared up front when writing the docx package, so rubyzip 3 no longer adds ZIP64 headers (version needed to extract 4.5) that OPC readers such as Word and Google Docs reject

## 0.1.8

Bugfix:

- Fix FrozenError when used with `--enable=frozen-string-literal` (RUBYOPT); all mutable string accumulators now initialised with `+""` or `+<<~HEREDOC`

## 0.1.7

Feature:

- Add ability to inline highlight parts

## 0.1.6

Bugfix:

- Stop additional page being added after content. Add known issue.

## 0.1.5

Bugfix:

- Should insert image with correct aspect ratio if only one dimension is specified

## 0.1.4

Bugfix:

- Removed accidentally left debug statement

## 0.1.3

Bugfix:

- Files that contain a PNG but weren't named ending in .png (e.g. a Tempfile in Ruby) were causing corrupted Docx files (which Word could auto-recover)

## 0.1.2

Features:

- Add 'after' to images and paragraphs to adjust spacing after those elements

## 0.1.1

Features:

- Allow combining bold, italic and underline on a single element (thanks to @b0nn1e for the PR)

## 0.1.0

Features:

- Implemented Document#bounds_width and Document#bounds_height

## 0.0.9

Features:

- Fixed page layout loading

## 0.0.8

Features:

- Allow changing of following section's page layout

## 0.0.7

Features:

- Table support

## 0.0.6

Features:

- Tab stops and hanging indents done
- Replacing of {CHECKBOX_EMPTY} and {CHECKBOX_CHECKED} with correct UTF-8 characters done

## 0.0.5

Features:

- Paragraph font name, size, colour and yellow highlight done
- Document level default font name, size and colour done

## 0.0.4

Features:

- Image insertion is working

## 0.0.3

Features:

- Dividers and page breaks implemented
- Simple HTML parsing (for paragraphs) implemented

## 0.0.2

Features:

- Able to generate a valid docx file, with no styling or anything useful yet

## 0.0.1

Features:

- Brand new code/gem generated
