// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.intera.roostrap.web;

import com.intera.roostrap.domain.City;
import com.intera.roostrap.domain.Country;
import com.intera.roostrap.web.CityController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect CityController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String CityController.create(@Valid City city, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, city);
            return "cities/create";
        }
        uiModel.asMap().clear();
        city.persist();
        return "redirect:/cities/" + encodeUrlPathSegment(city.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String CityController.createForm(Model uiModel) {
        populateEditForm(uiModel, new City());
        return "cities/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String CityController.show(@PathVariable("id") String id, Model uiModel) {
        uiModel.addAttribute("city", City.findCity(id));
        uiModel.addAttribute("itemId", id);
        return "cities/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String CityController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("cities", City.findCityEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) City.countCities() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("cities", City.findAllCities(sortFieldName, sortOrder));
        }
        return "cities/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String CityController.update(@Valid City city, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, city);
            return "cities/update";
        }
        uiModel.asMap().clear();
        city.merge();
        return "redirect:/cities/" + encodeUrlPathSegment(city.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String CityController.updateForm(@PathVariable("id") String id, Model uiModel) {
        populateEditForm(uiModel, City.findCity(id));
        return "cities/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String CityController.delete(@PathVariable("id") String id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        City city = City.findCity(id);
        city.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/cities";
    }
    
    void CityController.populateEditForm(Model uiModel, City city) {
        uiModel.addAttribute("city", city);
        uiModel.addAttribute("countries", Country.findAllCountries());
    }
    
    String CityController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}