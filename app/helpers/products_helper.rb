module ProductsHelper
    def highlighted_title(product)
        if product.try(:highlight).try(:title)
            product.highlight.title[0].html_safe
        else
            product.title
        end
    end
end
