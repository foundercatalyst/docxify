# CHANGELOG

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
