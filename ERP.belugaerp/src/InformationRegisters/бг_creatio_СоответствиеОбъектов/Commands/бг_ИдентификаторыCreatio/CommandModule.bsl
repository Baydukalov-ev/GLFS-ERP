
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ОбъектERP", ПараметрКоманды);
	
	ОткрытьФорму(
		"РегистрСведений.бг_creatio_СоответствиеОбъектов.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти