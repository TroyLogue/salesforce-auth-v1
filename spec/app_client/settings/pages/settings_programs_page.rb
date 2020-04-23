module Settings

    class ProgramTable < BasePage

        PROGRAMS_TABLE = { css: ".programs" }       
        PROGRAMS_TABLE_LOAD = { xpath: "h2[text()='Loading Programs...']" }
        NEW_PROGRAM_BTN = { css: '.ui-button.ui-button--primary' }
        PROGRAMS_LIST = { css: ".ui-base-card-header__title" }
        PROGRAM_EDIT = { xpath: ".//h2[text()='%s']/following-sibling::div/div/button" }

        def page_displayed?
            is_not_displayed?(PROGRAMS_TABLE_LOAD)
            is_displayed?(PROGRAMS_TABLE)
        end

        def get_list_of_programs
            names = find_elements(PROGRAMS_LIST)
            names_array = names.collect(&:text)
        end

        def edit_program(name:)
            click(PROGRAM_EDIT.transform_values{|v| v % name})
        end
        
        def go_to_new_program_form
            click(NEW_PROGRAM_BTN)
        end
    end

    class ProgramCard < BasePage
        PROGRAM_HEADER = { css: '.ui-base-card-header__title' }

        def get_program_title
            text(PROGRAM_HEADER)
        end

    end

end
